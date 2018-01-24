defmodule Spejs.Api.Utils do
  def atomize_shallow(%{} = map) do
    map
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
    |> Enum.into(%{})
  end

  def parse_integer("0x" <> string) do
    # Take take only integer part of parsing
    elem(case string do
      "0x" <> hex_string -> Integer.parse(hex_string)
      other -> Integer.parse(other)
    end, 0)
  end
end
