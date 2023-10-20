defmodule Core.Scrapper.Page do
  use Ecto.Schema
  import Ecto.Changeset
  use Core.Schema

  @link_regex ~r/((https?:\/\/)|(ftp:\/\/)|(^))([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+([a-zA-Z]{2,9})(:\d{1,4})?([-\w\/#~:.?+=&%@~]*)/

  @allowed_status [:started, :in_progress, :finished, :error]

  @required [:title, :total_links, :link, :user_id]
  @optional [:status]

  schema "pages" do
    field :title, :string
    field :total_links, :integer
    field :link, :string
    field :status, Ecto.Enum, values: @allowed_status, default: :started
    belongs_to :user, Core.Accounts.User
    has_many :links, Core.Scrapper.Link
    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_format(
      :link,
      @link_regex
    )
    |> validate_number(:total_links, greater_than: 0)
    |> cast_assoc(:user)
  end

  def progress_changeset(schema, progress) do
    schema
    |> cast(progress, @required ++ @optional)
    |> validate_required(@required)
  end

  def is_valid_link?(link), do: Regex.match?(@link_regex, link)
end
