defmodule Core.Ports.HtmlParser do
  @adapter Application.compile_env!(:ex_crap, [__MODULE__, :adapter])

  @type html_tree :: term()

  @callback content(html_tree) :: binary() | nil
  @callback get_attribute(binary() | html_tree(), binary()) :: list()
  @callback find_element(html_tree, css_selector :: String.t() | binary()) :: html_tree() | nil
  @callback parse_html(html_string :: String.t()) :: html_tree() | nil

  @spec content(html_tree) :: binary() | nil
  defdelegate content(html_tree), to: @adapter

  @spec find_element(html_tree, css_selector :: String.t() | binary()) :: html_tree() | nil
  defdelegate find_element(html_tree, css_selector), to: @adapter

  @spec get_attribute(binary() | html_tree(), binary()) :: list()
  defdelegate get_attribute(html, attribute_name), to: @adapter

  @spec parse_html(html_string :: String.t()) :: html_tree() | :error
  defdelegate parse_html(url), to: @adapter
end
