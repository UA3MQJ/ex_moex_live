defmodule ExMoexLive.BoardGroupsTest do
  use ExMoexLive.DataCase

  alias ExMoexLive.BoardGroups

  describe "board_groups" do
    alias ExMoexLive.BoardGroups.BoardGroup

    import ExMoexLive.BoardGroupsFixtures

    @invalid_attrs %{board_group_id: nil, category: nil, is_default: nil, is_order_driven: nil, is_traded: nil, market_id: nil, market_name: nil, name: nil, title: nil, trade_engine_id: nil, trade_engine_name: nil, trade_engine_title: nil}

    test "list_board_groups/0 returns all board_groups" do
      board_group = board_group_fixture()
      assert BoardGroups.list_board_groups() == [board_group]
    end

    test "get_board_group!/1 returns the board_group with given id" do
      board_group = board_group_fixture()
      assert BoardGroups.get_board_group!(board_group.id) == board_group
    end

    test "create_board_group/1 with valid data creates a board_group" do
      valid_attrs = %{board_group_id: 42, category: "some category", is_default: 42, is_order_driven: 42, is_traded: 42, market_id: 42, market_name: "some market_name", name: "some name", title: "some title", trade_engine_id: 42, trade_engine_name: "some trade_engine_name", trade_engine_title: "some trade_engine_title"}

      assert {:ok, %BoardGroup{} = board_group} = BoardGroups.create_board_group(valid_attrs)
      assert board_group.board_group_id == 42
      assert board_group.category == "some category"
      assert board_group.is_default == 42
      assert board_group.is_order_driven == 42
      assert board_group.is_traded == 42
      assert board_group.market_id == 42
      assert board_group.market_name == "some market_name"
      assert board_group.name == "some name"
      assert board_group.title == "some title"
      assert board_group.trade_engine_id == 42
      assert board_group.trade_engine_name == "some trade_engine_name"
      assert board_group.trade_engine_title == "some trade_engine_title"
    end

    test "create_board_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BoardGroups.create_board_group(@invalid_attrs)
    end

    test "update_board_group/2 with valid data updates the board_group" do
      board_group = board_group_fixture()
      update_attrs = %{board_group_id: 43, category: "some updated category", is_default: 43, is_order_driven: 43, is_traded: 43, market_id: 43, market_name: "some updated market_name", name: "some updated name", title: "some updated title", trade_engine_id: 43, trade_engine_name: "some updated trade_engine_name", trade_engine_title: "some updated trade_engine_title"}

      assert {:ok, %BoardGroup{} = board_group} = BoardGroups.update_board_group(board_group, update_attrs)
      assert board_group.board_group_id == 43
      assert board_group.category == "some updated category"
      assert board_group.is_default == 43
      assert board_group.is_order_driven == 43
      assert board_group.is_traded == 43
      assert board_group.market_id == 43
      assert board_group.market_name == "some updated market_name"
      assert board_group.name == "some updated name"
      assert board_group.title == "some updated title"
      assert board_group.trade_engine_id == 43
      assert board_group.trade_engine_name == "some updated trade_engine_name"
      assert board_group.trade_engine_title == "some updated trade_engine_title"
    end

    test "update_board_group/2 with invalid data returns error changeset" do
      board_group = board_group_fixture()
      assert {:error, %Ecto.Changeset{}} = BoardGroups.update_board_group(board_group, @invalid_attrs)
      assert board_group == BoardGroups.get_board_group!(board_group.id)
    end

    test "delete_board_group/1 deletes the board_group" do
      board_group = board_group_fixture()
      assert {:ok, %BoardGroup{}} = BoardGroups.delete_board_group(board_group)
      assert_raise Ecto.NoResultsError, fn -> BoardGroups.get_board_group!(board_group.id) end
    end

    test "change_board_group/1 returns a board_group changeset" do
      board_group = board_group_fixture()
      assert %Ecto.Changeset{} = BoardGroups.change_board_group(board_group)
    end
  end
end
