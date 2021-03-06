defmodule MeadowWeb.Schema.Mutation.CreateSheet do
  use MeadowWeb.ConnCase, async: true
  use Wormwood.GQLCase

  load_gql(MeadowWeb.Schema, "test/gql/CreateIngestSheet.gql")

  test "should be a valid mutation" do
    project = project_fixture()

    result =
      query_gql(
        variables: %{
          "title" => "Test Ingest Sheet",
          "filename" => "Test.csv",
          "projectId" => project.id
        },
        context: gql_context()
      )

    assert {:ok, query_data} = result

    title = get_in(query_data, [:data, "createIngestSheet", "title"])
    assert title == "Test Ingest Sheet"
  end
end
