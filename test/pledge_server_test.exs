defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "should store at most 3 pledges" do
    PledgeServer.start()

    pledges = [
      {"larry", 10},
      {"moe", 20},
      {"julie", 30},
      {"garry", 40}
    ]

    Enum.each(pledges, fn {name, amount} ->
      PledgeServer.create_pledge(name, amount)
    end)

    assert PledgeServer.recent_pledges() == [{"garry", 40}, {"julie", 30}, {"moe", 20}]
    assert PledgeServer.total_pledged() == 90
  end
end
