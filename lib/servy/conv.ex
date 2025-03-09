defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_headers: %{"Content-Type" => "text/html"},
            resp_body: "",
            status: nil

  def full_status(%Servy.Conv{status: status}) do
    "#{status} #{status_reason(status)}"
  end

  def put_resp_content_type(%Servy.Conv{} = conv, resp_content_type) do
    headers = Map.put(conv.resp_headers, "Content-Type", resp_content_type)
    %{conv | resp_headers: headers}
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
