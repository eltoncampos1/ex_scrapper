defmodule Core.Link do
  alias Core.Repo
  alias Core.Scrapper.Link
  import Ecto.Query

  def create(params) do
    %Link{}
    |> Link.changeset(params)
    |> IO.inspect()
    |> Repo.insert()
  end

  def by_page_id(page_id, opts) do
    from(l in Link, as: :link)
    |> where([link: l], l.page_id == ^page_id)
    |> Repo.paginate(opts)
  end
end
