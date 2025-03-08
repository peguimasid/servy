defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil

  def full_status(%Servy.Conv{status: status}) do
    "#{status} #{status_reason(status)}"
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
