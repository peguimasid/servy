defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledged() do
    GenServer.call(@name, :total_pledged)
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  # Server callbacks

  def init(state) do
    state = %{state | pledges: fetch_recent_pledges_from_service()}
    {:ok, state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    pledges = Enum.take(state.pledges, size)
    state = %{state | pledges: pledges, cache_size: size}
    {:noreply, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_info(message, state) do
    IO.puts("Unexpected man: #{inspect(message)}")
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    :timer.sleep(500)
    [{"wilma", 15}, {"fred", 25}]
  end
end

# alias Servy.PledgeServer

# {:ok, pid} = PledgeServer.start()

# send(pid, {:test, "no message like that"})

# IO.inspect(PledgeServer.create_pledge("test1", 10))
# IO.inspect(PledgeServer.create_pledge("test2", 20))
# IO.inspect(PledgeServer.create_pledge("test3", 30))
# IO.inspect(PledgeServer.create_pledge("test4", 40))
# IO.inspect(PledgeServer.create_pledge("test5", 50))

# PledgeServer.set_cache_size(2)

# PledgeServer.clear()

# IO.inspect(PledgeServer.recent_pledges())

# IO.inspect(PledgeServer.total_pledged())

# IO.inspect(Process.info(pid, :messages))

# {:ok, agent} = Agent.start(fn -> [] end)
# Agent.update(agent, fn(state) -> [ {"larry", 10} | state ] end)
# Agent.update(agent, fn(state) -> [ {"moe", 20} | state ] end)
# Agent.get(agent, fn(state) -> state end)
