defmodule Servy.Fetcher do
  def async(func) do
    parent_pid = self()

    spawn(fn -> send(parent_pid, {self(), :result, func.()}) end)
  end

  def get_result(pid) do
    receive do
      {^pid, :result, value} -> value
    after
      2000 ->
        raise "Take too long!"
    end
  end
end
