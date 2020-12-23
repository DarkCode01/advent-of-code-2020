defmodule Custom do
  @file_path "./input.txt"

  def process do
    File.read!(@file_path)
    |> String.split("\n")
    |> Stream.chunk_by(& &1 != "")
    |> Stream.map(fn data ->
      {Enum.count(data), data}
    end)
    |> Enum.map(&count_votes/1)
    |> Enum.sum()
  end

  def count_votes({_, [""]}) do
    0
  end
  def count_votes({1, votes}) do
    votes
    |> parser_value()
    |> Enum.uniq()
    |> Enum.reduce(0, fn _x, acc -> acc + 1 end)
  end
  def count_votes({persons, votes}) do
    votes
    |> parser_value()
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.filter(& &1 >= persons)
    |> Enum.count()
  end

  defp parser_value(value) do
    value
    |> Enum.join("")
    |> String.split("", trim: true)
  end
end

Custom.process() |> IO.inspect()
