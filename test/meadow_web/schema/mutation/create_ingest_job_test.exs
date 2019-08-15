defmodule MeadowWeb.Schema.Mutation.CreateIngestJob do
  use MeadowWeb.ConnCase, async: true

  @query """
    mutation ($name: String!, $filename: String!, $projectId: ID!) {
      createIngestJob(name: $name, filename: $filename, projectId: $projectId) {
        name
        filename
        project {
          id
        }
      }
    }
  """

  test "createIngestJob mutation creates an ingest job for a project", _context do
    project = project_fixture()

    input = %{
      "name" => "This is the name",
      "filename" => "filename.csv",
      "projectId" => project.id
    }

    conn = build_conn()

    conn =
      post conn, "/api/graphql",
        query: @query,
        variables: input

    assert %{
             "data" => %{
               "createIngestJob" => %{
                 "name" => "This is the name",
                 "filename" => "filename.csv",
                 "project" => %{
                   "id" => project.id
                 }
               }
             }
           } == json_response(conn, 200)
  end
end
