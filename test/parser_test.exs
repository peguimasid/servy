defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "should parse a list of headers fields into a map" do
    header_lines = ["A: 1", "B: 2"]
    headers = Parser.parse_headers(header_lines)
    assert headers == %{"A" => "1", "B" => "2"}
  end
end
