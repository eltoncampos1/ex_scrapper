defmodule Core.Ports.HttpHandler do
  @adapter Application.compile_env!(:ex_crap, [__MODULE__, :adapter])
  @callback get(url :: String.t()) :: {:ok, term()} | {:error, term()}

   @spec get(url::  String.t()) :: {:ok, term()} | {:error, term()}
   defdelegate get(url), to: @adapter
end
