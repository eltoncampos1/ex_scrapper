defmodule Core.Adapters.HttpHandler.Finch do
  @behaviour Core.Ports.HttpHandler

  def get(url) do
    case Finch.build(:get, url) |> Finch.request(:ex_finch) do
      {:ok, %Finch.Response{body: body}} -> {:ok, body}
      {:error, _reason} = err -> err
    end
  end
end
