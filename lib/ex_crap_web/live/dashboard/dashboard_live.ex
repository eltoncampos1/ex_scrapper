defmodule CoreWeb.DashboardLive do
  alias Core.Link
  use CoreWeb, :live_view
  alias Core.Page
  alias Core.Link

  def handle_params(params, _uri, socket) do
    live_action = socket.assigns.live_action
    apply_action(socket, params, live_action)
  end

  def handle_event("start-scrap", %{"page_link" => link}, socket) do
    {:ok, %Finch.Response{body: body}} = Finch.build(:get, link) |> Finch.request(:ex_finch)
    IO.inspect(link)

    Floki.parse_document!(body)
    |> Floki.find("a")
    |> Enum.map(&Floki.attribute(&1, "href"))

    {:noreply, put_flash(socket, :info, "scrapping started")}
  end

  def handle_event("page-link", %{"id" => page_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/page/#{page_id}")}
  end

  defp apply_action(socket, params, :show) do
    user_id = socket.assigns.current_user.id
    opts = Page.by_user_id(user_id, page: get_page(params))

    {:noreply,
    socket
      |> assign_pagination(:pages, opts)}
  end

  defp apply_action(socket, %{"id" => page_id} = params, :page_links) do
    opts = Link.by_page_id(page_id, page: get_page(params))

    {:noreply,
     socket
     |> assign_pagination(:page_links, opts)
     |> assign(:id, page_id)
    }
  end

  defp get_page(%{"page" => page}), do: String.to_integer(page)
  defp get_page(_params), do: 1

  def assign_pagination(socket, entry_key, %{
      entries: entries,
      page_number: page_number,
      page_size: _page_size,
      total_entries: total_entries,
      total_pages: total_pages
    }) do
      socket
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> assign(:total_entries, total_entries)
     |> assign(entry_key, entries)
    end
end
