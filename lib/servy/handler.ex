defmodule Servy.Handler do
  @pages_path Path.expand("pages", File.cwd!())

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.Conv, only: [put_content_length: 1]

  alias Servy.Api
  alias Servy.Conv
  alias Servy.Controllers.BearController

  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> put_content_length()
    |> format_response()
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    params = Map.put(conv, "id", id)
    BearController.delete(conv, params)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Api.BearController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/api/bears", params: params} = conv) do
    Api.BearController.create(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path, method: method} = conv) do
    %{conv | status: 404, resp_body: "Route #{method} '#{path}' not found."}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{Conv.format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end
end
