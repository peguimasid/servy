defmodule Servy.Api.BearController do
  alias Servy.Conv
  alias Servy.Wildthings

  def index(conv) do
    json =
      Wildthings.list_bears()
      |> Poison.encode!()

    conv = Conv.put_resp_content_type(conv, "application/json")

    %{conv | status: 200, resp_body: json}
  end
end
