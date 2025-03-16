defmodule Servy.PledgeServer do
  @name :pledge_server

  alias Servy.GenericServer

  def start do
    GenericServer.start(__MODULE__, [], @name)
  end

  def create_pledge(name, amount) do
    GenericServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenericServer.call(@name, :recent_pledges)
  end

  def total_pledged() do
    GenericServer.call(@name, :total_pledged)
  end

  def clear() do
    GenericServer.cast(@name, :clear)
  end

  # Server callbacks

  def handle_cast(:clear, _state) do
    []
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()
    {total, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServer

# pid = PledgeServer.start()

# send(pid, {:test, "no message like that"})

# IO.inspect(PledgeServer.create_pledge("test1", 10))
# IO.inspect(PledgeServer.create_pledge("test2", 20))
# IO.inspect(PledgeServer.create_pledge("test3", 30))
# IO.inspect(PledgeServer.create_pledge("test4", 40))

# PledgeServer.clear()

# IO.inspect(PledgeServer.create_pledge("test5", 50))

# IO.inspect(PledgeServer.recent_pledges())

# IO.inspect(PledgeServer.total_pledged())

# IO.inspect(Process.info(pid, :messages))

# {:ok, agent} = Agent.start(fn -> [] end)
# Agent.update(agent, fn(state) -> [ {"larry", 10} | state ] end)
# Agent.update(agent, fn(state) -> [ {"moe", 20} | state ] end)
# Agent.get(agent, fn(state) -> state end)
