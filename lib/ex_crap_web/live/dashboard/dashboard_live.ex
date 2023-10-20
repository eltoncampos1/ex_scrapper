defmodule CoreWeb.DashboardLive do
  alias Core.Scrapper
  alias Core.Link
  use CoreWeb, :live_view
  alias Core.Page
  alias Core.Link

  alias Core.Dashboard.Components

  def handle_params(params, _uri, socket) do
    live_action = socket.assigns.live_action

    user_id = get_user_id(socket)
    if connected?(socket), do: Scrapper.subscribe(user_id)

    apply_action(socket, params, live_action)
  end

  def handle_event("start-scrap", %{"page_link" => link}, socket) do
    if Core.Scrapper.Page.is_valid_link?(link) do
      user_id = get_user_id(socket)
      Core.Scrapper.execute(link, user_id)
      {:noreply, socket}
    else
      {:noreply, put_flash(socket, :error, "Plis provide a valid url")}
    end
  end

  def handle_event("page-link", %{"id" => page_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/page/#{page_id}")}
  end

  def handle_info({:scraper_status, message}, socket) do
    {:noreply, put_flash(socket, :info, message)}
  end

  def handle_info({:new_page_scrapping, page}, socket) do
    {:noreply, update(socket, :pages, fn pages -> [page | pages] end)}
  end

  defp apply_action(socket, params, :show) do
    user_id = get_user_id(socket)
    opts = Page.by_user_id(user_id, page: get_page(params))

    {:noreply,
     socket
     |> assign_pagination(:pages, opts)
     |> assign(page_id: nil)}
  end

  defp apply_action(socket, %{"id" => page_id} = params, :page_links) do
    opts = Link.by_page_id(page_id, page: get_page(params))

    {:noreply,
     socket
     |> assign_pagination(:page_links, opts)
     |> assign(page_id: page_id)
     |> assign_page(page_id)}
  end

  defp assign_page(socket, page_id) do
    assign(socket, page: Page.by_id(page_id))
  end

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

  defp get_user_id(socket), do: socket.assigns.current_user.id

  defp get_page(%{"page" => page}), do: String.to_integer(page)
  defp get_page(_params), do: 1

  def route(page_id, page) when not is_nil(page_id), do: ~p"/page/#{page_id}?page=#{page}"
  def route(_, page), do: ~p"/dashboard?page=#{page}"
end
