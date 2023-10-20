defmodule Core.Page do
  alias Core.Accounts.User
  alias Core.Scrapper.Page
  alias Core.Repo

  import Ecto.Query

  def create(params) do
    %Page{}
    |> Page.changeset(params)
    |> Repo.insert()
  end

  def delete(page) do
    Repo.delete!(page)
  end

  def update_status(page, progress) do
    params = %{status: progress}

    page
    |> Page.progress_changeset(params)
    |> Repo.update()
  end

  def by_user_id(user_id, opts \\ []) do
    from(u in User, as: :user)
    |> join(:inner, [user: u], p in Page, as: :page, on: p.user_id == ^user_id)
    |> select([page: p], p)
    |> order_by([page: p], desc: p.inserted_at)
    |> Repo.paginate(opts)
  end

  def by_id(id) do
    Repo.get(Page, id)
  end
end
