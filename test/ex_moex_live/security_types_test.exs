defmodule ExMoexLive.SecurityTypesTest do
  use ExMoexLive.DataCase

  alias ExMoexLive.SecurityTypes

  describe "security_types" do
    alias ExMoexLive.SecurityTypes.SecurityType

    import ExMoexLive.SecurityTypesFixtures

    @invalid_attrs %{security_group_name: nil, security_type_name: nil, security_type_title: nil, stock_type: nil, trade_engine_id: nil, trade_engine_name: nil, trade_engine_title: nil}

    test "list_security_types/0 returns all security_types" do
      security_type = security_type_fixture()
      assert SecurityTypes.list_security_types() == [security_type]
    end

    test "get_security_type!/1 returns the security_type with given id" do
      security_type = security_type_fixture()
      assert SecurityTypes.get_security_type!(security_type.id) == security_type
    end

    test "create_security_type/1 with valid data creates a security_type" do
      valid_attrs = %{security_group_name: "some security_group_name", security_type_name: "some security_type_name", security_type_title: "some security_type_title", stock_type: "some stock_type", trade_engine_id: 42, trade_engine_name: "some trade_engine_name", trade_engine_title: "some trade_engine_title"}

      assert {:ok, %SecurityType{} = security_type} = SecurityTypes.create_security_type(valid_attrs)
      assert security_type.security_group_name == "some security_group_name"
      assert security_type.security_type_name == "some security_type_name"
      assert security_type.security_type_title == "some security_type_title"
      assert security_type.stock_type == "some stock_type"
      assert security_type.trade_engine_id == 42
      assert security_type.trade_engine_name == "some trade_engine_name"
      assert security_type.trade_engine_title == "some trade_engine_title"
    end

    test "create_security_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SecurityTypes.create_security_type(@invalid_attrs)
    end

    test "update_security_type/2 with valid data updates the security_type" do
      security_type = security_type_fixture()
      update_attrs = %{security_group_name: "some updated security_group_name", security_type_name: "some updated security_type_name", security_type_title: "some updated security_type_title", stock_type: "some updated stock_type", trade_engine_id: 43, trade_engine_name: "some updated trade_engine_name", trade_engine_title: "some updated trade_engine_title"}

      assert {:ok, %SecurityType{} = security_type} = SecurityTypes.update_security_type(security_type, update_attrs)
      assert security_type.security_group_name == "some updated security_group_name"
      assert security_type.security_type_name == "some updated security_type_name"
      assert security_type.security_type_title == "some updated security_type_title"
      assert security_type.stock_type == "some updated stock_type"
      assert security_type.trade_engine_id == 43
      assert security_type.trade_engine_name == "some updated trade_engine_name"
      assert security_type.trade_engine_title == "some updated trade_engine_title"
    end

    test "update_security_type/2 with invalid data returns error changeset" do
      security_type = security_type_fixture()
      assert {:error, %Ecto.Changeset{}} = SecurityTypes.update_security_type(security_type, @invalid_attrs)
      assert security_type == SecurityTypes.get_security_type!(security_type.id)
    end

    test "delete_security_type/1 deletes the security_type" do
      security_type = security_type_fixture()
      assert {:ok, %SecurityType{}} = SecurityTypes.delete_security_type(security_type)
      assert_raise Ecto.NoResultsError, fn -> SecurityTypes.get_security_type!(security_type.id) end
    end

    test "change_security_type/1 returns a security_type changeset" do
      security_type = security_type_fixture()
      assert %Ecto.Changeset{} = SecurityTypes.change_security_type(security_type)
    end
  end
end
