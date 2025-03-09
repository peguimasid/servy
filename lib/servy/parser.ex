defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n", parts: 2)

    [request_line | header_lines] = String.split(top, "\r\n")

    [method, path, _version] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn line, acc ->
      [key, value] = String.split(line, ": ")
      Map.put(acc, key, value)
    end)
  end

  @doc """
  Parses the given params string based on the content type.

  ## Parameters

    - content_type: The content type of the params string (string).
    - params_string: The params string to be parsed (string).

  ## Examples

      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", "name=Ballo&type=Brown")
      %{"name" => "Ballo", "type" => "Brown"}
      iex> Servy.Parser.parse_params("multipart/form-data", "name=Ballo&type=Brown")
      %{}

  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}
end
