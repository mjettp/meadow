defmodule Meadow.Ingest.Progress do
  @moduledoc """
  Translate action state notifications into ingest sheet progress notifications
  """
  alias Meadow.Ingest.Schemas.{Progress, Row, Sheet}
  alias Meadow.Pipeline
  alias Meadow.Repo

  import Ecto.Query
  import Meadow.Utils.Atoms

  defstruct sheet_id: nil,
            total_file_sets: 0,
            completed_file_sets: 0,
            total_actions: 0,
            completed_actions: 0,
            percent_complete: 0

  @doc """
  Retrieve all progress entries for an ingest sheet
  """
  def get_entries(sheet) do
    progress_entries(sheet)
    |> Repo.all()
  end

  @doc """
  Retrieve a progress entry by ingest sheet row ID and action name
  """
  def get_entry(%Row{} = row, action), do: get_entry(row.id, action)

  def get_entry(row_id, action) do
    action = atom_to_string(action)

    from(p in Progress, where: p.row_id == ^row_id and p.action == ^action)
    |> Repo.one()
  end

  @doc """
  Initialize progress entries for a given ingest sheet row, including
  an additional entry if the row creates a new work
  """
  def initialize_entry(%Row{} = row, include_work), do: initialize_entry(row.id, include_work)

  def initialize_entry(row_id, include_work) do
    row_actions(include_work)
    |> Enum.each(fn action -> update_entry(row_id, action, "pending") end)
  end

  def initialize_entries(entries) do
    timestamp = DateTime.utc_now()

    entries
    |> Enum.chunk_every(500)
    |> Enum.each(&initialize_chunk(&1, timestamp))
  end

  defp initialize_chunk(chunk, timestamp) do
    new_entries =
      Enum.flat_map(chunk, fn {row_id, include_work} ->
        row_actions(include_work)
        |> Enum.map(fn action ->
          %{
            row_id: row_id,
            action: atom_to_string(action),
            status: "pending",
            inserted_at: timestamp,
            updated_at: timestamp
          }
        end)
      end)

    Repo.insert_all(Progress, new_entries)
  end

  @doc """
  Update the status of a progress entry for a given ingest sheet row and action
  """
  def update_entry(%Row{} = row, action, status), do: update_entry(row.id, action, status)

  def update_entry(row_id, action, status) do
    progress =
      case get_entry(row_id, action) do
        nil -> %Progress{row_id: row_id, action: atom_to_string(action)}
        row -> row
      end
      |> Progress.changeset(%{status: status})
      |> Repo.insert_or_update!()

    send_notification(progress)

    progress
  end

  @doc """
  Get the total number of actions for an ingest sheet
  """
  def action_count(sheet) do
    sheet
    |> progress_entries()
    |> Repo.aggregate(:count)
  end

  @doc """
  Get the number of completed actions for an ingest sheet
  """
  def completed_count(sheet) do
    from([entry: p] in progress_entries(sheet), where: p.status in ["ok", "error"])
    |> Repo.aggregate(:count)
  end

  @doc """
  Get the total number of file sets for an ingest sheet
  """
  def file_set_count(sheet) do
    from([entry: p] in progress_entries(sheet),
      where: p.action == "Meadow.Pipeline.Actions.FileSetComplete"
    )
    |> Repo.aggregate(:count)
  end

  @doc """
  Get the number of completed file sets for an ingest sheet
  """
  def completed_file_set_count(sheet) do
    from([entry: p] in progress_entries(sheet),
      where:
        p.action == "Meadow.Pipeline.Actions.FileSetComplete" and
          p.status in ["ok", "error"]
    )
    |> Repo.aggregate(:count)
  end

  defp row_actions(include_work) do
    if include_work do
      ["CreateWork" | Pipeline.actions()]
    else
      Pipeline.actions()
    end
  end

  defp progress_entries(%Sheet{} = sheet), do: progress_entries(sheet.id)

  defp progress_entries(sheet_id) do
    from p in Progress,
      as: :entry,
      join: r in Row,
      as: :row,
      on: r.id == p.row_id,
      where: r.sheet_id == ^sheet_id
  end

  @doc """
  Get the total progress report for an ingest sheet
  """
  def pipeline_progress(%Sheet{} = sheet), do: pipeline_progress(sheet.id)

  def pipeline_progress(sheet_id) do
    case action_count(sheet_id) do
      0 ->
        %__MODULE__{sheet_id: sheet_id}

      action_count ->
        completed_action_count = completed_count(sheet_id)
        percent_complete = round(completed_action_count / action_count * 10_000) / 100

        %__MODULE__{
          sheet_id: sheet_id,
          total_file_sets: file_set_count(sheet_id),
          completed_file_sets: completed_file_set_count(sheet_id),
          total_actions: action_count,
          completed_actions: completed_action_count,
          percent_complete: percent_complete
        }
    end
  end

  @doc """
  Send a progress report notification every time a progress record changes
  """
  def send_notification(%Progress{} = record) do
    with sheet_id <- record |> Repo.preload(:row) |> Map.get(:row) |> Map.get(:sheet_id) do
      Absinthe.Subscription.publish(
        MeadowWeb.Endpoint,
        pipeline_progress(sheet_id),
        ingest_progress: sheet_id
      )
    end
  end

  def send_notification(_), do: :noop
end
