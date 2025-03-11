defmodule Servy.HttpClient do
  def send_request(request) do
    localhost = ~c"localhost"
    {:ok, socket} = :gen_tcp.connect(localhost, 4000, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)
    response
  end
end
