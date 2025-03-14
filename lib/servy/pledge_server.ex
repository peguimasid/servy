defmodule Servy.PledgeServer do
  def create_pledge(name, amount) do
    {:ok, id} = send_pledge_to_service(name, amount)
  end

  def recent_pledges do
    #
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
