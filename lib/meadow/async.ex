defmodule Meadow.Async do
  @moduledoc """
  Performs singleton tasks asynchronously using Elixir's built-in Registry
  """

  @environment Mix.env()

  @doc """
  Find a running singleton task with the given label
  """
  def find_task(label) do
    case Meadow.TaskRegistry |> Registry.lookup(label) do
      [{pid, _}] -> pid
      _ -> nil
    end
  end

  @doc """
  Kill the singleton task with the given label
  """
  def kill!(label) do
    case find_task(label) do
      nil ->
        {false, :not_found}

      pid ->
        Meadow.TaskRegistry |> Registry.unregister(label)
        {Process.exit(pid, :kill), pid}
    end
  end

  @doc """
  List all running singleton tasks and their pids
  """
  def list_tasks do
    Meadow.TaskRegistry
    |> Registry.select([{{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}])
    |> Enum.map(fn {label, pid, _} -> {label, pid} end)
  end

  @doc """
  Kick off a labeled singleton task. If a task with the same label is
  already running, returns `{:running, pid}`. Otherwise, starts the
  task and returns `{:ok, pid}`
  """
  def run_once(label, fun) do
    run_once(label, fun, @environment)
  end

  def run_once(label, fun, :test) do
    send(self(), {label, fun.()})
    {:sync, self()}
  end

  def run_once(label, fun, _env) do
    case find_task(label) do
      nil ->
        receiver = self()

        Task.start(fn ->
          try do
            Meadow.TaskRegistry |> Registry.register(label, nil)
            send(receiver, {label, fun.()})
          after
            Meadow.TaskRegistry |> Registry.unregister(label)
          end
        end)

      pid ->
        {:running, pid}
    end
  end
end
