defmodule AirtableEx.Client do
  defstruct token: System.get_env("AIRTABLE_TOKEN"),
            endpoint: "https://api.airtable.com/v0/",
            params: %{}
  def new(), do: %__MODULE__{}
end
