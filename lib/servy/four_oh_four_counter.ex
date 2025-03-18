defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter_server

  use GenServer

  def start_link(_args) do
    IO.puts("Starting 404 counter server...")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def bump_count(route) do
    GenServer.call(@name, {:bump, route})
  end

  def get_count(route) do
    GenServer.call(@name, {:get, route})
  end

  def get_counts() do
    GenServer.call(@name, :list)
  end

  def reset() do
    GenServer.cast(@name, :reset)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call({:bump, route}, _from, state) do
    current_value = Map.get(state, route, 0)
    new_state = Map.put(state, route, current_value + 1)
    {:reply, :ok, new_state}
  end

  def handle_call({:get, route}, _from, state) do
    amount = Map.get(state, route, 0)
    {:reply, amount, state}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:reset, _state) do
    {:noreply, %{}}
  end

  def handle_info(message, state) do
    IO.puts("Unexpected man: #{inspect(message)}")
    {:noreply, state}
  end
end
