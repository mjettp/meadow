defmodule MeadowWeb.Schema.Mutation.BatchUpdateTest do
  use MeadowWeb.ConnCase, async: true
  use Meadow.DataCase
  use Wormwood.GQLCase
  alias Meadow.Data.Indexer

  load_gql(MeadowWeb.Schema, "test/gql/BatchUpdate.gql")

  setup do
    prewarm_controlled_term_cache()

    work_fixture(%{
      descriptive_metadata: %{
        title: "Work 1",
        contributor: [
          %{
            role: %{scheme: "marc_relator", id: "aut"},
            term: %{id: "http://id.loc.gov/authorities/names/n50053919"}
          }
        ],
        genre: [
          %{role: nil, term: %{id: "http://vocab.getty.edu/aat/300386217"}},
          %{role: nil, term: %{id: "http://vocab.getty.edu/aat/300139140"}}
        ]
      }
    })

    Indexer.reindex_all!()
    :ok
  end

  test "should be a valid mutation" do
    result =
      query_gql(
        variables: %{
          "query" => ~s'{"query":{"term":{"workType.id": "IMAGE"}}}',
          "delete" => %{
            "contributor" => [
              %{
                "role" => %{"scheme" => "MARC_RELATOR", "id" => "aut"},
                "term" => "http://id.loc.gov/authorities/names/n50053919"
              }
            ],
            "genre" => [
              %{"term" => "http://vocab.getty.edu/aat/300139140"}
            ]
          }
        },
        context: gql_context()
      )

    assert {:ok, query_data} = result

    response = get_in(query_data, [:data, "batchUpdate", "message"])
    assert response == "Batch started"
  end
end
