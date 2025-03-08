defmodule Servy.Plugins do
  alias Servy.Conv

  def track(%Conv{status: 404, path: path} = conv) do
    IO.inspect(conv, label: "Error in call for #{path}")
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect(conv, label: "Request after parse")
end
