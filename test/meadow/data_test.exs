defmodule Meadow.DataTest do
  use Meadow.DataCase

  alias Meadow.Data
  alias Meadow.Repo

  describe "queries" do
    test "get_work_by_file_set_id/1 fetches the work for that file_set" do
      work = work_with_file_sets_fixture(1) |> Repo.preload(:file_sets)
      file_set_id = List.first(work.file_sets).id
      assert Data.get_work_by_file_set_id(file_set_id).id == work.id
    end

    test "ranked_file_sets_for_work/1" do
      work = work_with_file_sets_fixture(2)

      [file_set_1, file_set_2] = Data.ranked_file_sets_for_work(work.id)
      assert file_set_1.rank < file_set_2.rank
    end

    test "query/2 returns its queryable" do
      assert Data.query(:input, :ignored) == :input
    end
  end
end
