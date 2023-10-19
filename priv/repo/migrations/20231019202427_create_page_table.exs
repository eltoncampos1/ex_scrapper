defmodule Core.Repo.Migrations.CreatePageTable do
  use Ecto.Migration

  def change do
    create table(:pages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :link, :string
      add :total_links, :integer
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      timestamps()
    end
  end
end
