defmodule ExMoexLive.SecurityCollectionsTest do
  use ExMoexLive.DataCase

  alias ExMoexLive.SecurityCollections

  describe "security_collections" do
    alias ExMoexLive.SecurityCollections.SecurityCollection

    import ExMoexLive.SecurityCollectionsFixtures

    @invalid_attrs %{name: nil, security_group_id: nil, title: nil}

    test "list_security_collections/0 returns all security_collections" do
      security_collection = security_collection_fixture()
      assert SecurityCollections.list_security_collections() == [security_collection]
    end

    test "get_security_collection!/1 returns the security_collection with given id" do
      security_collection = security_collection_fixture()
      assert SecurityCollections.get_security_collection!(security_collection.id) == security_collection
    end

    test "create_security_collection/1 with valid data creates a security_collection" do
      valid_attrs = %{name: "some name", security_group_id: 42, title: "some title"}

      assert {:ok, %SecurityCollection{} = security_collection} = SecurityCollections.create_security_collection(valid_attrs)
      assert security_collection.name == "some name"
      assert security_collection.security_group_id == 42
      assert security_collection.title == "some title"
    end

    test "create_security_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SecurityCollections.create_security_collection(@invalid_attrs)
    end

    test "update_security_collection/2 with valid data updates the security_collection" do
      security_collection = security_collection_fixture()
      update_attrs = %{name: "some updated name", security_group_id: 43, title: "some updated title"}

      assert {:ok, %SecurityCollection{} = security_collection} = SecurityCollections.update_security_collection(security_collection, update_attrs)
      assert security_collection.name == "some updated name"
      assert security_collection.security_group_id == 43
      assert security_collection.title == "some updated title"
    end

    test "update_security_collection/2 with invalid data returns error changeset" do
      security_collection = security_collection_fixture()
      assert {:error, %Ecto.Changeset{}} = SecurityCollections.update_security_collection(security_collection, @invalid_attrs)
      assert security_collection == SecurityCollections.get_security_collection!(security_collection.id)
    end

    test "delete_security_collection/1 deletes the security_collection" do
      security_collection = security_collection_fixture()
      assert {:ok, %SecurityCollection{}} = SecurityCollections.delete_security_collection(security_collection)
      assert_raise Ecto.NoResultsError, fn -> SecurityCollections.get_security_collection!(security_collection.id) end
    end

    test "change_security_collection/1 returns a security_collection changeset" do
      security_collection = security_collection_fixture()
      assert %Ecto.Changeset{} = SecurityCollections.change_security_collection(security_collection)
    end
  end
end
