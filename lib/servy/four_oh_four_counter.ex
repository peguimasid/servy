defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter_server

  alias Servy.GenericServer

  def start() do
    GenericServer.start(__MODULE__, %{}, @name)
  end

  def bump_count(route) do
    GenericServer.call(@name, {:bump, route})
  end

  def get_count(route) do
    GenericServer.call(@name, {:get, route})
  end

  def get_counts() do
    GenericServer.call(@name, :list)
  end

  def reset() do
    GenericServer.cast(@name, :reset)
  end

  def handle_call({:bump, route}, state) do
    current_value = Map.get(state, route, 0)
    new_state = Map.put(state, route, current_value + 1)
    {:ok, new_state}
  end

  def handle_call({:get, route}, state) do
    amount = Map.get(state, route, 0)
    {amount, state}
  end

  def handle_call(:list, state) do
    {state, state}
  end

  def handle_cast(:reset, _state) do
    %{}
  end

  def handle_info(message, state) do
    IO.puts("Unexpected man: #{inspect(message)}")
    {:noreply, state}
  end
end
