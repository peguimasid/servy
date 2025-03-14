defmodule Servy.Controllers.BearController do
  alias Servy.Wildthings
  alias Servy.Bear
  import Servy.View, only: [render: 3]

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{conv | status: 201, resp_body: "Created #{type} bear named #{name}"}
  end

  def delete(conv, %{"id" => id}) do
    %{conv | status: 403, resp_body: "Nah leave bear #{id} alone"}
  end
end
