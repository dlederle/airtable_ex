defmodule AirtableEx do
  use HTTPoison.Base
  alias AirtableEx.Client

  @moduledoc """
  Wrapper around Airtable API

  records =  AirtableEx.Client.new()
  |> base(BASE_ID)
  |> table(table_name)
  |> index()
  """

  def process_response_body(body) do
    body
    |> Poison.decode!()
  end

  defp append_to_endpoint(%Client{} = client, arg) do
    client
    |> Map.put(:endpoint, client.endpoint <> arg <> "/")
  end

  def base(%Client{} = client, base_id) do
    append_to_endpoint(client, base_id)
  end

  def table(%Client{} = client, table_name) do
    append_to_endpoint(client, table_name)
  end

  def view(%Client{} = client, view) do
    client
    |> Map.put(:params, Map.put(client.params, :view, view))
  end

  def view(client, _), do: client

  def headers(token) do
    [
      {"Authorization", "Bearer #{token}"},
      {"Content-Type", "application/json"}
    ]
  end

  def index(%Client{} = client) do
    index_query(client)
    |> extract_records()
  end

  def index_query(%Client{endpoint: endpoint, token: token}) do
    endpoint
    # |> parameterize(params)
    |> get(headers(token))
  end

  def show(%Client{} = client, record_id) do
    show_query(client, record_id)
    |> extract_record()
  end

  def show_query(%Client{endpoint: endpoint, token: token}, record_id) do
    (endpoint <> record_id)
    # |> parameterize(params)
    |> get(headers(token))
  end

  def extract_record({
        :ok,
        %HTTPoison.Response{body: body}
      }) do
    body
  end

  def extract_records({
        :ok,
        %HTTPoison.Response{body: %{"records" => records}}
      }) do
    records
  end
end
