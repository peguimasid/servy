defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_headers: %{"Content-Type" => "text/html", "Content-Length" => 0},
            resp_body: "",
            status: nil

  def full_status(%Servy.Conv{status: status}) do
    "#{status} #{status_reason(status)}"
  end

  def put_resp_content_type(%Servy.Conv{} = conv, resp_content_type) do
    headers = Map.put(conv.resp_headers, "Content-Type", resp_content_type)
    %{conv | resp_headers: headers}
  end

  def put_content_length(%Servy.Conv{} = conv) do
    headers = Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body))
    %{conv | resp_headers: headers}
  end

  def format_response_headers(%Servy.Conv{resp_headers: resp_headers}) do
    resp_headers
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.map(fn {key, value} -> "#{key}: #{value}\r" end)
    |> Enum.join("\n")
  end

  defp status_reason(code) do
    case code do
      200 -> "OK"
      201 -> "Created"
      401 -> "Unauthorized"
      403 -> "Forbidden"
      404 -> "Not Found"
      500 -> "Internal Server Error"
      _ -> "Unknown Status"
    end
  end
end
