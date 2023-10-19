defmodule Core.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      alias Ecto.Changeset
      import Ecto.Changeset

      @type t :: %__MODULE__{}
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
