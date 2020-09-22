defmodule Meadow.AsyncTest do
  use ExUnit.Case

  import Assertions

  describe "sync (test) mode" do
    test "runs synchronously" do
      assert {:sync, _} =
               Meadow.Async.run_once("test:123", fn ->
                 :synchronous_test_result
               end)

      assert_received({"test:123", :synchronous_test_result})
    end
  end

  describe "async mode" do
    test "runs asynchronously" do
      assert {:ok, _} =
               Meadow.Async.run_once(
                 "test:123",
                 fn ->
                   :asynchronous_test_result
                 end,
                 :dev
               )

      assert_receive({"test:123", :asynchronous_test_result}, 1000)
    end

    test "detects a running process" do
      assert {:ok, pid} =
               Meadow.Async.run_once(
                 "test:123",
                 fn ->
                   assert {:running, _} =
                            Meadow.Async.run_once("test:123", fn -> :result end, :dev)
                 end,
                 :dev
               )

      assert_receive({"test:123", {:running, pid}}, 1000)
    end
  end

  describe "process management" do
    setup do
      [123, 456, 789]
      |> Enum.map(fn id ->
        Meadow.Async.run_once(
          "test:#{id}",
          fn -> :timer.sleep(:infinity) end,
          :dev
        )
      end)

      on_exit(fn ->
        Meadow.Async.list_tasks()
        |> Enum.each(fn {_, pid} -> Process.exit(pid, :kill) end)
      end)

      :timer.sleep(1)
      :ok
    end

    test "list_tasks/0" do
      assert_lists_equal(
        Meadow.Async.list_tasks()
        |> Enum.map(fn {id, _pid} -> id end),
        ["test:123", "test:456", "test:789"]
      )
    end

    test "find_task/1" do
      assert Meadow.Async.find_task("test:000") |> is_nil()
      assert Meadow.Async.find_task("test:123") |> is_pid()
    end

    test "kill!/1" do
      assert {false, :not_found} == Meadow.Async.kill!("test:000")
      assert {true, pid} = Meadow.Async.kill!("test:123")
      assert is_pid(pid)
      :timer.sleep(1)
      assert {false, :not_found} == Meadow.Async.kill!("test:123")
      assert Meadow.Async.list_tasks() |> length() == 2
    end
  end
end
