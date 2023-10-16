defmodule ExMoexLive.BoardsTest do
  use ExMoexLive.DataCase

  alias ExMoexLive.Boards

  describe "boards" do
    alias ExMoexLive.Boards.Board

    import ExMoexLive.BoardsFixtures

    @invalid_attrs %{board_group_id: nil, board_title: nil, boardid: nil, engine_id: nil, has_candles: nil, is_primary: nil, is_traded: nil, market_id: nil}

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Boards.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Boards.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{board_group_id: 42, board_title: "some board_title", boardid: "some boardid", engine_id: 42, has_candles: 42, is_primary: 42, is_traded: 42, market_id: 42}

      assert {:ok, %Board{} = board} = Boards.create_board(valid_attrs)
      assert board.board_group_id == 42
      assert board.board_title == "some board_title"
      assert board.boardid == "some boardid"
      assert board.engine_id == 42
      assert board.has_candles == 42
      assert board.is_primary == 42
      assert board.is_traded == 42
      assert board.market_id == 42
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{board_group_id: 43, board_title: "some updated board_title", boardid: "some updated boardid", engine_id: 43, has_candles: 43, is_primary: 43, is_traded: 43, market_id: 43}

      assert {:ok, %Board{} = board} = Boards.update_board(board, update_attrs)
      assert board.board_group_id == 43
      assert board.board_title == "some updated board_title"
      assert board.boardid == "some updated boardid"
      assert board.engine_id == 43
      assert board.has_candles == 43
      assert board.is_primary == 43
      assert board.is_traded == 43
      assert board.market_id == 43
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_board(board, @invalid_attrs)
      assert board == Boards.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Boards.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Boards.change_board(board)
    end
  end
end
