defmodule ExMoexLive.DurationsTest do
  use ExMoexLive.DataCase

  alias ExMoexLive.Durations

  describe "durations" do
    alias ExMoexLive.Durations.Duration

    import ExMoexLive.DurationsFixtures

    @invalid_attrs %{days: nil, duration: nil, hint: nil, interval: nil, title: nil}

    test "list_durations/0 returns all durations" do
      duration = duration_fixture()
      assert Durations.list_durations() == [duration]
    end

    test "get_duration!/1 returns the duration with given id" do
      duration = duration_fixture()
      assert Durations.get_duration!(duration.id) == duration
    end

    test "create_duration/1 with valid data creates a duration" do
      valid_attrs = %{days: 42, duration: 42, hint: "some hint", interval: 42, title: "some title"}

      assert {:ok, %Duration{} = duration} = Durations.create_duration(valid_attrs)
      assert duration.days == 42
      assert duration.duration == 42
      assert duration.hint == "some hint"
      assert duration.interval == 42
      assert duration.title == "some title"
    end

    test "create_duration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Durations.create_duration(@invalid_attrs)
    end

    test "update_duration/2 with valid data updates the duration" do
      duration = duration_fixture()
      update_attrs = %{days: 43, duration: 43, hint: "some updated hint", interval: 43, title: "some updated title"}

      assert {:ok, %Duration{} = duration} = Durations.update_duration(duration, update_attrs)
      assert duration.days == 43
      assert duration.duration == 43
      assert duration.hint == "some updated hint"
      assert duration.interval == 43
      assert duration.title == "some updated title"
    end

    test "update_duration/2 with invalid data returns error changeset" do
      duration = duration_fixture()
      assert {:error, %Ecto.Changeset{}} = Durations.update_duration(duration, @invalid_attrs)
      assert duration == Durations.get_duration!(duration.id)
    end

    test "delete_duration/1 deletes the duration" do
      duration = duration_fixture()
      assert {:ok, %Duration{}} = Durations.delete_duration(duration)
      assert_raise Ecto.NoResultsError, fn -> Durations.get_duration!(duration.id) end
    end

    test "change_duration/1 returns a duration changeset" do
      duration = duration_fixture()
      assert %Ecto.Changeset{} = Durations.change_duration(duration)
    end
  end
end
