defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse()
    |> log()
    |> route()
    |> format_response()
  end

  def log(conv), do: IO.inspect(conv, label: "Request after parse")

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{path: path} = conv) do
    %{conv | resp_body: "No #{path} here!"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.inspect(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.inspect(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.inspect(response)
