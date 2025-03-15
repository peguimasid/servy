defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  # Client interface functions

  def start() do
    pid = spawn(__MODULE__, :listen_loop, [%{}])
    Process.register(pid, @name)
    pid
  end

  def bump_count(route) do
    send(@name, {self(), :bump, route})

    receive do
      {:response, status} -> status
    end
  end

  def get_count(route) do
    send(@name, {self(), :get, route})

    receive do
      {:response, amount} -> amount
    end
  end

  def get_counts() do
    send(@name, {self(), :list})

    receive do
      {:response, values} -> values
    end
  end

  # Server

  def listen_loop(state) do
    receive do
      {sender, :bump, route} ->
        current_value = Map.get(state, route, 0)
        new_state = Map.put(state, route, current_value + 1)
        send(sender, {:response, :ok})
        listen_loop(new_state)

      {sender, :get, route} ->
        amount = Map.get(state, route)
        send(sender, {:response, amount})
        listen_loop(state)

      {sender, :list} ->
        send(sender, {:response, state})
        listen_loop(state)

      unexpected ->
        IO.puts("Unexpected message #{inspect(unexpected)}")
        listen_loop(state)
    end
  end
end

# alias Servy.PledgeServer

# pid = PledgeServer.start()

# send(pid, {:stop, "test"})

# IO.inspect(PledgeServer.create_pledge("test1", 10))
# IO.inspect(PledgeServer.create_pledge("test2", 20))
# IO.inspect(PledgeServer.create_pledge("test3", 30))
# IO.inspect(PledgeServer.create_pledge("test4", 40))
# IO.inspect(PledgeServer.create_pledge("test5", 50))

# IO.inspect(PledgeServer.recent_pledges())

# IO.inspect(PledgeServer.total_pledged())

# IO.inspect(Process.info(pid, :messages))

# {:ok, agent} = Agent.start(fn -> [] end)
# Agent.update(agent, fn(state) -> [ {"larry", 10} | state ] end)
# Agent.update(agent, fn(state) -> [ {"moe", 20} | state ] end)
# Agent.get(agent, fn(state) -> state end)
