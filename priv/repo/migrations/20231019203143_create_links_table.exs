defmodule Core.Repo.Migrations.CreateLinksTable do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text
      add :href, :string
      add :user_id, references(:pages, on_delete: :delete_all, type: :binary_id), null: false
      timestamps()
    end
  end
end
