defmodule Servy do
  use Application

  def start(_type, _start_args) do
    IO.puts("Starting the application...")
    Servy.Supervisor.start_link()
  end
end
