defmodule Core.Scrapper do
  require Logger
  alias Core.Scrapper.Page
  alias Core.Repo

  use GenServer

  @name :ex_craper_server
  @topic "scrapper"

  def start_link(_) do
    GenServer.start_link(__MODULE__, @name, name: @name)
  end

  def init(name) do
    {:ok, name}
  end

  def execute(link, user_id), do: GenServer.cast(@name, {:execute, link, user_id})

  def handle_cast({:execute, link, user_id}, name) do
    handle_execute(link, user_id)
    {:noreply, name}
  end

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(Core.PubSub, "#{@topic}:#{user_id}")
  end

  def broadcast(user_id, message) do
    Phoenix.PubSub.broadcast(Core.PubSub, "#{@topic}:#{user_id}", message)
  end

  def handle_execute(link, user_id) do
    broadcast(user_id, {:scraper_status, "Scrapper Started!"})

    with {:ok, html_body} <- make_request(link, user_id),
         html_tree when not is_nil(html_tree) <- parse_html_body(html_body),
         page_title when not is_nil(page_title) <- find_page_title(html_tree),
         links when not is_nil(links) <- find_links(html_tree),
         page_params <- build_page_params(page_title, link, links, user_id),
         {:ok, page} <- insert_page(page_params) do
      buil_links(links, page.id)
      |> insert_links(page)

      broadcast(user_id, {:scraper_status, "Scrapping has successfully succeeded"})
    else
      err ->
        Logger.error("#{__MODULE__}:: Something went wrong #{inspect(err)}")
        broadcast(user_id, {:scraper_status, "Something went wrong"})
    end
  end

  defp insert_links(links, page) do
    with {:ok, %Page{} = page} <- Core.Page.update_status(page, :in_progress),
         _results <- Enum.each(links, &Core.Link.create/1) do
      Core.Page.update_status(page, :finished)
    end
  end

  defp buil_links(links, page_id) do
    Enum.map(links, &build_link(&1, page_id))
  end

  defp build_link(link, page_id) do
    %{
      page_id: page_id,
      content: get_link_content(link),
      href: Core.Ports.HtmlParser.get_attribute(link, "href") |> hd
    }
  end

  defp get_link_content(link) do
    case Core.Ports.HtmlParser.content(link) do
      nil ->
        "no content"

      "" ->
        "no content"

      content ->
        content = String.slice(content, 0..20)
        :iconv.convert("utf-8", "iso8859-15", content)
    end
  end

  defp insert_page(page_param) do
    case Core.Page.create(page_param) do
      {:ok, page} = res ->
        broadcast(page_param.user_id, {:new_page_scrapping, page})
        res

      err ->
        err
    end
  end

  defp build_page_params(title, link, links, user_id) do
    total_links = Enum.count(links)
    broadcast(user_id, {:scraper_status, "Founded #{total_links} links"})

    %{
      title: title,
      link: link,
      user_id: user_id,
      status: :started,
      total_links: total_links
    }
  end

  defp make_request(link, user_id) do
    broadcast(user_id, {:scraper_status, "Making requests to: #{link}"})
    Core.Ports.HttpHandler.get(link)
  end

  defp parse_html_body(body), do: Core.Ports.HtmlParser.parse_html(body)

  defp find_page_title(html_tree) do
    html_tree
    |> Core.Ports.HtmlParser.find_element("title")
    |> Core.Ports.HtmlParser.content()
  end

  defp find_links(html_tree),
    do: Core.Ports.HtmlParser.find_element(html_tree, "a[href]:not([href=\"\"]")
end
