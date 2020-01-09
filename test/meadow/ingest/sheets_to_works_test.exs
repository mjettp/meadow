defmodule Meadow.Ingest.SheetsToWorksTest do
  use Meadow.DataCase
  alias Meadow.Ingest.{Sheets, SheetWorks, SheetsToWorks}
  alias Meadow.Data.{FileSets, Works}
  alias Meadow.Repo

  @fixture "test/fixtures/ingest_sheet.csv"
  @fixture_works 2
  @fixture_file_sets 7

  setup do
    sheet = ingest_sheet_rows_fixture(@fixture)

    {:ok, sheet: sheet}
  end

  test "create works from ingest sheet", %{sheet: sheet} do
    SheetsToWorks.create_works_from_ingest_sheet(sheet)
    sheet = sheet |> Repo.preload(:works)
    assert length(sheet.works) == @fixture_works
    assert length(Works.list_works()) == @fixture_works
    assert length(Sheets.list_ingest_sheet_works(sheet)) == @fixture_works
    assert length(FileSets.list_file_sets()) == @fixture_file_sets
    assert length(Repo.preload(sheet, :works).works) == @fixture_works
    assert length(SheetWorks.get_file_sets_and_rows(sheet)) == @fixture_file_sets

    with work <- List.first(sheet.works) |> Repo.preload(:file_sets),
         file_set <- List.first(work.file_sets) do
      assert SheetWorks.ingest_sheet_for(work) |> Map.get(:id) == sheet.id
      assert SheetWorks.ingest_sheet_for(file_set) |> Map.get(:id) == sheet.id
    end
  end
end
