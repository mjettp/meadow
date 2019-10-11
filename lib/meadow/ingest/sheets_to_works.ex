defmodule Meadow.Ingest.SheetsToWorks do
  @moduledoc """
  Functions to group IngestSheetRows into Works and FileSets
  and create the resulting database records
  """
  import Ecto.Query, warn: false
  alias Meadow.Config
  alias Meadow.Data.{AuditEntries, FileSets.FileSet, Works}
  alias Meadow.Ingest.{Actions, IngestSheets, Pipeline}
  alias Meadow.Ingest.IngestSheets.{IngestSheet, IngestSheetRow}
  alias Meadow.Repo

  use Meadow.Constants

  def create_works_from_ingest_sheet(%IngestSheet{} = ingest_sheet) do
    work_records = group_by_works(ingest_sheet)

    work_records
    |> Enum.map(fn work_record -> ingest_work(work_record) end)
    |> Enum.reject(fn work -> is_nil(work) end)
    |> IngestSheets.link_works_to_ingest_sheet(ingest_sheet)

    ingest_sheet
  end

  def group_by_works(%IngestSheet{} = ingest_sheet) do
    IngestSheets.list_ingest_sheet_rows(sheet: ingest_sheet)
    |> Enum.group_by(fn row -> row |> IngestSheetRow.field_value(:work_accession_number) end)
  end

  def start_file_set_pipelines(ingest_sheet) do
    from([file_set: file_set, row: row] in IngestSheets.file_sets_and_rows(ingest_sheet),
      select: %{file_set_id: file_set.id, row_num: row.row}
    )
    |> Repo.all()
    |> Enum.each(fn %{row_num: row_num, file_set_id: file_set_id} ->
      IngestSheets.update_ingest_status(ingest_sheet.id, row_num, "pending")
      AuditEntries.initialize_entries({FileSet, file_set_id}, Pipeline.actions())

      Actions.IngestFileSet.send_message(
        %{file_set_id: file_set_id},
        %{context: "IngestSheet", ingest_sheet: ingest_sheet.id, ingest_sheet_row: row_num}
      )
    end)

    ingest_sheet
  end

  defp ingest_work({accession_number, file_set_rows}) do
    ingest_bucket = Config.ingest_bucket()

    result =
      Repo.transaction(fn ->
        attrs = %{
          accession_number: accession_number,
          visibility: @default_visibility,
          work_type: "image",
          metadata: %{},
          file_sets:
            file_set_rows
            |> Enum.map(fn row ->
              file_path = IngestSheetRow.field_value(row, :filename)
              location = "s3://#{ingest_bucket}/#{file_path}"

              %{
                accession_number: row |> IngestSheetRow.field_value(:accession_number),
                role: row |> IngestSheetRow.field_value(:role),
                metadata: %{
                  description: row |> IngestSheetRow.field_value(:description),
                  location: location,
                  original_filename: Path.basename(file_path)
                }
              }
            end)
        }

        case Works.create_work(attrs) do
          {:ok, work} ->
            work

          {:error, changeset} ->
            Repo.rollback(changeset)
        end
      end)

    case result do
      {:ok, %Works.Work{} = work} ->
        AuditEntries.add_entry!(work, "CreateWork", "ok")
        work

      {:error, changeset} ->
        create_changeset_errors(changeset, file_set_rows)
    end
  end

  defp create_changeset_errors(changeset, file_set_rows) do
    with row <- file_set_rows |> List.first() do
      create_errors(
        row,
        "CreateWork",
        errors_to_strings(changeset.errors)
      )
    end

    file_set_rows
    |> Enum.with_index()
    |> Enum.each(fn {row, index} ->
      with fs_changeset <- Enum.at(changeset.changes.file_sets, index) do
        create_errors(
          row,
          "CreateFileSet",
          errors_to_strings(fs_changeset.errors)
        )
      end
    end)

    nil
  end

  defp create_errors(ingest_sheet_row, action, []) do
    AuditEntries.add_entry!(ingest_sheet_row, action, "skipped")
  end

  defp create_errors(ingest_sheet_row, action, errors) do
    AuditEntries.add_entry!(ingest_sheet_row, action, "error", Enum.join(errors, "; "))
  end

  defp errors_to_strings(errors) do
    errors
    |> Enum.map(fn {field, {message, _opts}} ->
      [to_string(field), message] |> Enum.join(": ")
    end)
  end
end
