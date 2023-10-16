defmodule ExMoexLive.EnginesTest do
  use ExMoexLive.DataCase

  alias ExMoexLive.Engines

  describe "engines" do
    alias ExMoexLive.Engines.Engine

    import ExMoexLive.EnginesFixtures

    @invalid_attrs %{name: nil, title: nil}

    test "list_engines/0 returns all engines" do
      engine = engine_fixture()
      assert Engines.list_engines() == [engine]
    end

    test "get_engine!/1 returns the engine with given id" do
      engine = engine_fixture()
      assert Engines.get_engine!(engine.id) == engine
    end

    test "create_engine/1 with valid data creates a engine" do
      valid_attrs = %{name: "some name", title: "some title"}

      assert {:ok, %Engine{} = engine} = Engines.create_engine(valid_attrs)
      assert engine.name == "some name"
      assert engine.title == "some title"
    end

    test "create_engine/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engines.create_engine(@invalid_attrs)
    end

    test "update_engine/2 with valid data updates the engine" do
      engine = engine_fixture()
      update_attrs = %{name: "some updated name", title: "some updated title"}

      assert {:ok, %Engine{} = engine} = Engines.update_engine(engine, update_attrs)
      assert engine.name == "some updated name"
      assert engine.title == "some updated title"
    end

    test "update_engine/2 with invalid data returns error changeset" do
      engine = engine_fixture()
      assert {:error, %Ecto.Changeset{}} = Engines.update_engine(engine, @invalid_attrs)
      assert engine == Engines.get_engine!(engine.id)
    end

    test "delete_engine/1 deletes the engine" do
      engine = engine_fixture()
      assert {:ok, %Engine{}} = Engines.delete_engine(engine)
      assert_raise Ecto.NoResultsError, fn -> Engines.get_engine!(engine.id) end
    end

    test "change_engine/1 returns a engine changeset" do
      engine = engine_fixture()
      assert %Ecto.Changeset{} = Engines.change_engine(engine)
    end
  end
end
