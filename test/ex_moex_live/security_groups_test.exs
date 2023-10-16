defmodule ExMoexLive.SecurityGroupsTest do
  use ExMoexLive.DataCase

  alias ExMoexLive.SecurityGroups

  describe "security_groups" do
    alias ExMoexLive.SecurityGroups.SecurityGroup

    import ExMoexLive.SecurityGroupsFixtures

    @invalid_attrs %{is_hidden: nil, name: nil, title: nil}

    test "list_security_groups/0 returns all security_groups" do
      security_group = security_group_fixture()
      assert SecurityGroups.list_security_groups() == [security_group]
    end

    test "get_security_group!/1 returns the security_group with given id" do
      security_group = security_group_fixture()
      assert SecurityGroups.get_security_group!(security_group.id) == security_group
    end

    test "create_security_group/1 with valid data creates a security_group" do
      valid_attrs = %{is_hidden: 42, name: "some name", title: "some title"}

      assert {:ok, %SecurityGroup{} = security_group} = SecurityGroups.create_security_group(valid_attrs)
      assert security_group.is_hidden == 42
      assert security_group.name == "some name"
      assert security_group.title == "some title"
    end

    test "create_security_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SecurityGroups.create_security_group(@invalid_attrs)
    end

    test "update_security_group/2 with valid data updates the security_group" do
      security_group = security_group_fixture()
      update_attrs = %{is_hidden: 43, name: "some updated name", title: "some updated title"}

      assert {:ok, %SecurityGroup{} = security_group} = SecurityGroups.update_security_group(security_group, update_attrs)
      assert security_group.is_hidden == 43
      assert security_group.name == "some updated name"
      assert security_group.title == "some updated title"
    end

    test "update_security_group/2 with invalid data returns error changeset" do
      security_group = security_group_fixture()
      assert {:error, %Ecto.Changeset{}} = SecurityGroups.update_security_group(security_group, @invalid_attrs)
      assert security_group == SecurityGroups.get_security_group!(security_group.id)
    end

    test "delete_security_group/1 deletes the security_group" do
      security_group = security_group_fixture()
      assert {:ok, %SecurityGroup{}} = SecurityGroups.delete_security_group(security_group)
      assert_raise Ecto.NoResultsError, fn -> SecurityGroups.get_security_group!(security_group.id) end
    end

    test "change_security_group/1 returns a security_group changeset" do
      security_group = security_group_fixture()
      assert %Ecto.Changeset{} = SecurityGroups.change_security_group(security_group)
    end
  end
end
