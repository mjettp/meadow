defmodule MeadowWeb.Plugs.Elasticsearch do
  @moduledoc """
  Plug to proxy Elasticsearch requests from the front end
  """
  import Plug.Conn

  alias Elasticsearch.Cluster.Config

  @behaviour Plug
  @accepted_methods ["POST", "GET", "OPTIONS", "HEAD"]

  require Logger

  def init(default), do: default

  def call(conn, opts) do
    case conn.method in @accepted_methods do
      true ->
        process_request(conn, opts)

      false ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(401, "Unauthorized")
        |> send_resp()
    end
  end

  def process_request(conn, _default) do
    body = extract_body(conn)
    [_base, path] = String.split(conn.request_path, "/elasticsearch")
    query_string = extract_query_string(conn.query_string)

    config =
      Config.build(
        nil,
        Application.get_env(:meadow, Meadow.ElasticsearchCluster)
      )

    case config |> config[:api].request(conn.method, path <> query_string, body, []) do
      {:ok, response} ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(200, Jason.encode!(response.body))
        |> send_resp()

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("#{__MODULE__} error: #{reason}")

        conn
        |> put_resp_content_type("application/json")
        |> resp(500, Jason.encode!(reason))
        |> send_resp()

      other ->
        other
    end
  end

  defp extract_query_string(<<" "::binary, rest::binary>>), do: extract_query_string(rest)

  defp extract_query_string(string) when string == "",
    do: ""

  defp extract_query_string(string) when is_binary(string),
    do: "?#{string}"

  defp extract_body(%Plug.Conn{body_params: %Plug.Conn.Unfetched{aspect: :body_params}} = conn) do
    {:ok, body, _conn} = read_body(conn)
    body
  end

  defp extract_body(conn) do
    conn.body_params
  end
end
