defmodule Core.Repo.Migrations.AddStatusToPageTable do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :status, :string
    end
  end
end
