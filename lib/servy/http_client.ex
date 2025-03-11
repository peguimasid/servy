defmodule Servy.HttpClient do
  def send_request(request) do
    localhost = ~c"localhost"
    {:ok, socket} = :gen_tcp.connect(localhost, 4567, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)
    response
  end
end

request = """
GET /bears HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

spawn(fn -> Servy.HttpServer.start(4567) end)

response = Servy.HttpClient.send_request(request)

IO.inspect(response)
