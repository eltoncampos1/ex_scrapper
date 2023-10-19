defmodule CoreWeb.DashboardLive do
  use CoreWeb, :live_view

  def handle_event("start-scrap", %{"page_link" => link}, socket) do
   {:ok, %Finch.Response{body: body}} =  Finch.build(:get, link) |> Finch.request(:ex_finch)
   IO.inspect(link)
    Floki.parse_document!(body) |> Floki.find("a")
    |> Enum.map(&Floki.attribute(&1,"href"))

    {:noreply, put_flash(socket,:info, "scrapping started")}
  end
end
