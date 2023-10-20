defmodule Core.Scrapper.Link do
  use Ecto.Schema
  import Ecto.Changeset
  use Core.Schema

  @required [:content, :href, :page_id]

  schema "links" do
    field :content, :string
    field :href, :string
    belongs_to :page, Core.Scrapper.Page

    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required)
    |> validate_required(@required)
    |> cast_assoc(:page)
  end
end
