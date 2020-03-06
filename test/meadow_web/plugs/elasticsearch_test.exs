defmodule ElasticsearchTest do
  use MeadowWeb.ConnCase, async: false
  use Meadow.IndexCase

  alias Meadow.Data.Works

  describe "MeadowWeb.Plugs.Elasticsearch" do
    setup do
      %{works: [work | _]} = indexable_data()
      {:ok, work} = Works.update_work(work, %{descriptive_metadata: %{title: "Test Fixture"}})
      synchronize()
      {:ok, %{work: work}}
    end

    test "only accepts methods: [POST, GET, OPTIONS, HEAD]", %{work: work} do
      conn =
        build_conn()
        |> auth_user(user_fixture())
        |> delete("/elasticsearch/meadow/_doc/#{work.id}")

      assert conn.status == 400
    end

    test "returns results for _search reqeusts" do
      conn =
        build_conn()
        |> auth_user(user_fixture())
        |> put_req_header("content-type", "application/json")
        |> post(
          "/elasticsearch/meadow/_search",
          Jason.encode!(%{"query" => %{"match_all" => %{}}})
        )

      assert Jason.decode!(conn.resp_body)["hits"]["total"] == indexed_doc_count()
    end

    test "returns results for _msearch reqeusts" do
      mquery = """
      { }
      {"query":{"match":{"title":"Test Fixture"}}}
      """

      conn =
        build_conn()
        |> auth_user(user_fixture())
        |> put_req_header("content-type", "application/x-ndjson")
        |> post("/elasticsearch/meadow/_msearch", mquery)

      assert Jason.decode!(conn.resp_body)
        |> Map.get("responses")
        |> List.first()
        |> get_in(["hits", "total"]) == 1
    end

    test "returns results for query string requests" do
      conn =
        build_conn()
        |> auth_user(user_fixture())
        |> put_req_header("content-type", "application/json")
        |> get("/elasticsearch/meadow/_search?q=Test%20Fixture")

      assert Jason.decode!(conn.resp_body) |> get_in(["hits", "total"]) == 1
    end
  end
end
