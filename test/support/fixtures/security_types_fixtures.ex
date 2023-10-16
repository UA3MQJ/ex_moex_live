defmodule ExMoexLive.SecurityTypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.SecurityTypes` context.
  """

  @doc """
  Generate a security_type.
  """
  def security_type_fixture(attrs \\ %{}) do
    {:ok, security_type} =
      attrs
      |> Enum.into(%{
        security_group_name: "some security_group_name",
        security_type_name: "some security_type_name",
        security_type_title: "some security_type_title",
        stock_type: "some stock_type",
        trade_engine_id: 42,
        trade_engine_name: "some trade_engine_name",
        trade_engine_title: "some trade_engine_title"
      })
      |> ExMoexLive.SecurityTypes.create_security_type()

    security_type
  end
end
