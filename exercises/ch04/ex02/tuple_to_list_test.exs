if !System.get_env("PROGRAMMING_ERLANG_TEST_EXAMPLES") do
  Code.load_file("tuple_to_list.ex", __DIR__)
end

ExUnit.start()

defmodule TupleToListTest do
  use ExUnit.Case

  test "test the tuple to list" do
    assert TupleToList.tuple_to_list({:share, {{'Ericsson_B', 163}, "bxb"}}) ==
      [:share, {{'Ericsson_B', 163}, "bxb"}]
  end

end
