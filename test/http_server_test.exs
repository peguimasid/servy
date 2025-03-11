defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.{HttpServer}

  test "should receive correct response" do
    spawn(HttpServer, :start, [4000])

    {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")

    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end

  test "should receive correct responses" do
    spawn(HttpServer, :start, [4000])

    parent_pid = self()

    max_requests = 5

    for _ <- 1..max_requests do
      spawn(fn ->
        send(parent_pid, HTTPoison.get("http://localhost:4000/wildthings"))
      end)
    end

    for _ <- 1..max_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end
  end
end
