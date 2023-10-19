defmodule Core.Adapters.HtmlParser.Floki do
  @behaviour Core.Ports.HtmlParser

  def parse_html(html_string) do
    Floki.parse_document!(html_string)
  end

  def find_element(html_tree, css_selector), do: Floki.find(html_tree, css_selector)

  def get_attribute(html, attr_name), do: Floki.attribute(html, attr_name)

  def content(html_tree), do: Floki.text(html_tree)
end
