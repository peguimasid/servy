defmodule Servy.UserApi do
  def query(id) do
    case HTTPoison.get("https://jsonplaceholder.typicode.com/users/#{id}") do
      {:ok, %HTTPoison.Response{body: body}} ->
        json_body = Poison.Parser.parse!(body)
        {:ok, get_in(json_body, ["address", "city"])}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
