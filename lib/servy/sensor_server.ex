defmodule Servy.SensorServer do
  alias Servy.Tracker
  alias Servy.VideoCam

  @name :sensor_server

  use GenServer

  defmodule State do
    defstruct sensor_data: %{}, refresh_interval: :timer.minutes(60)
  end

  # Client Interface

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def set_refresh_interval(time_in_ms) when is_number(time_in_ms) do
    GenServer.cast(@name, {:set_refresh_interval, time_in_ms})
  end

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data)
  end

  # Server Callbacks

  def init(state) do
    sensor_data = run_tasks_to_get_sensor_data()
    state = %{state | sensor_data: sensor_data}
    schedule_refresh(state.refresh_interval)
    {:ok, state}
  end

  def handle_info(:refresh, state) do
    sensor_data = run_tasks_to_get_sensor_data()
    state = %{state | sensor_data: sensor_data}
    schedule_refresh(state.refresh_interval)
    IO.puts("Cache refreshed...")
    {:noreply, state}
  end

  def handle_info(unexpected, state) do
    IO.puts("Can't touch this! #{inspect(unexpected)}")
    {:noreply, state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set_refresh_interval, time_in_ms}, state) do
    state = %{state | refresh_interval: time_in_ms}
    schedule_refresh(time_in_ms)
    {:noreply, state}
  end

  defp schedule_refresh(refresh_interval) do
    Process.send_after(self(), :refresh, refresh_interval)
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts("Running tasks to get sensor data...")

    task = Task.async(fn -> Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
