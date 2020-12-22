defmodule Report do
  @file_path "./input.txt"

  def parse_input do
    File.read!(@file_path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def comb(_, 0), do: [[]]
  def comb([], _), do: []
  def comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end
end

Report.parse_input
|> Report.comb(3)
|> Enum.find(& Enum.sum(&1) == 2020)
|> Enum.reduce(& &1 * &2)
|> IO.inspect()
