alias Shell.Basic

defmodule Shell do
  def hello do
    Basic.init()
    add_one = fn x -> x + 1 end
    x = add_one.(3)
    IO.puts(x)
  end

  def tests do
    list = &[&1, &2]
    is_map = &(is_map/1)
    map = %{ a: "aaaa", b: "bbbb", c: "ccccc" }
    tuple = { :a, :b, :c }
    new_list = list.(5, 8)
    io = &(IO.inspect/2)
    io.(new_list, label: "The list is")
    _is_tuble = is_tuple(tuple)
    is_map = is_map.(map)
    io.(is_map, label: "xuxa")
  end
end
