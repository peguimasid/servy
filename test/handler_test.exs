defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 336\r
    \r
    <h1>All the bears!</h1>

    <ul>
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 404 Not Found\r
           Content-Type: text/html\r
           Content-Length: 31\r
           \r
           Route GET '/bigfoot' not found.
           """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 72\r
    \r
    <h1>Show bear!</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 30\r
           \r
           Created Brown bear named Baloo
           """
  end

  test "DELETE /bears/1" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r

    """

    response = handle(request)

    assert response == """
           HTTP/1.1 403 Forbidden\r
           Content-Type: text/html\r
           Content-Length: 22\r
           \r
           Nah leave bear 1 alone
           """
  end

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: 605

    [{"hibernating":true, "type":"Brown","name":"Teddy","id":1},
     {"hibernating":false, "type":"Black","name":"Smokey","id":2},
     {"hibernating":false, "type":"Brown","name":"Paddington","id":3},
     {"hibernating":true, "type":"Grizzly","name":"Scarface","id":4},
     {"hibernating":false, "type":"Polar","name":"Snow","id":5},
     {"hibernating":false, "type":"Grizzly","name":"Brutus","id":6},
     {"hibernating":true, "type":"Black","name":"Rosie","id":7},
     {"hibernating":false, "type":"Panda","name":"Roscoe","id":8},
     {"hibernating":true, "type":"Polar","name":"Iceman","id":9},
     {"hibernating":false, "type":"Grizzly","name":"Kenai","id":10}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
