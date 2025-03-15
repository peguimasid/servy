defmodule FourOhFourCounterTest do
  use ExUnit.Case

  alias Servy.FourOhFourCounter, as: Counter

  test "reports counts of missing path requests" do
    Counter.start()

    Counter.bump_count("/smallfoot")
    Counter.bump_count("/nessie")
    Counter.bump_count("/nessie")
    Counter.bump_count("/smallfoot")
    Counter.bump_count("/nessie")

    assert Counter.get_count("/nessie") == 3
    assert Counter.get_count("/smallfoot") == 2

    assert Counter.get_counts() == %{"/smallfoot" => 2, "/nessie" => 3}
  end
end
