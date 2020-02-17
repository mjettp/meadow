defmodule Meadow.Data.IndexerTest do
  @moduledoc false
  use Meadow.DataCase
  use Meadow.IndexCase
  alias Ecto.Adapters.SQL.Sandbox
  alias Meadow.Data.{Collections, Indexer, Works}
  alias Mix.Tasks.Elasticsearch.Build, as: BuildTask

  describe "indexing" do
    setup do
      {:ok, indexable_data()}
    end

    test "synchronize_index/0", %{count: count} do
      assert indexed_doc_count() == 0
      Indexer.synchronize_index()
      assert indexed_doc_count() == count
    end

    test "deleted", %{count: count, works: [work | _]} do
      assert indexed_doc_count() == 0
      Indexer.synchronize_index()
      assert indexed_doc_count() == count
      work |> Repo.delete()
      Indexer.synchronize_index()
      assert indexed_doc_count() == count - 3
    end
  end

  describe "dependent updates" do
    @tag unboxed: true
    test "collection name cascades to work" do
      Sandbox.unboxed_run(Repo, fn ->
        %{collection: collection, works: [work | _]} = indexable_data()

        Indexer.synchronize_index()
        assert indexed_doc(collection.id) |> get_in(["title"]) == collection.name
        assert indexed_doc(work.id) |> get_in(["collection", "title"]) == collection.name

        {:ok, collection} = collection |> Collections.update_collection(%{name: "New Name"})

        Indexer.synchronize_index()
        assert indexed_doc(collection.id) |> get_in(["title"]) == "New Name"
        assert indexed_doc(work.id) |> get_in(["collection", "title"]) == "New Name"
      end)
    end

    @tag unboxed: true
    test "work visibility cascades to file set" do
      Sandbox.unboxed_run(Repo, fn ->
        %{works: [work | _], file_sets: [file_set | _]} = indexable_data()

        Indexer.synchronize_index()
        assert indexed_doc(work.id) |> get_in(["visibility"]) == "restricted"
        assert indexed_doc(file_set.id) |> get_in(["visibility"]) == "restricted"

        {:ok, work} = work |> Works.update_work(%{visibility: "open"})

        Indexer.synchronize_index()
        assert indexed_doc(work.id) |> get_in(["visibility"]) == "open"
        assert indexed_doc(file_set.id) |> get_in(["visibility"]) == "open"
      end)
    end
  end

  describe "encoding" do
    setup do
      with %{collection: collection, works: works, file_sets: file_sets} <- indexable_data() do
        {:ok,
         %{
           collection: collection,
           work: List.first(works) |> Repo.preload(:collection),
           file_set: List.first(file_sets) |> Repo.preload(:work)
         }}
      end
    end

    test "collection encoding", %{collection: subject} do
      [header, doc] = subject |> Indexer.encode!(:index) |> decode_njson()
      assert header |> get_in(["index", "_id"]) == subject.id
      assert doc |> get_in(["model", "application"]) == "Meadow"
      assert doc |> get_in(["title"]) == subject.name
    end

    test "work encoding", %{work: subject} do
      [header, doc] = subject |> Indexer.encode!(:index) |> decode_njson()
      assert header |> get_in(["index", "_id"]) == subject.id
      assert doc |> get_in(["model", "application"]) == "Meadow"
      assert doc |> get_in(["title"]) == subject.descriptive_metadata.title
    end

    test "file set encoding", %{file_set: subject} do
      [header, doc] = subject |> Indexer.encode!(:index) |> decode_njson()
      assert header |> get_in(["index", "_id"]) == subject.id
      assert doc |> get_in(["model", "application"]) == "Meadow"
      assert doc |> get_in(["label"]) == subject.metadata.description
    end
  end

  describe "mix task" do
    setup do
      {:ok, indexable_data()}
    end

    test "mix elasticsearch.build", %{count: count} do
      assert indexed_doc_count() == 0

      ~w[meadow --cluster Meadow.ElasticsearchCluster]
      |> BuildTask.run()

      Elasticsearch.Index.refresh(Meadow.ElasticsearchCluster, "meadow")
      assert indexed_doc_count() == count
    end
  end
end