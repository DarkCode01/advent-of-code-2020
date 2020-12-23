defmodule BinaryBoarding do
  @file_path "./input.txt"

  def parse_input do
    File.read!(@file_path)
    |> String.split("\n", trim: true)
  end

  def process(input) do
    list =
      input
      |> Stream.map(& String.split(&1, "", trim: true))
      |> Stream.map(fn code ->
        Enum.reduce(code, %{row: {0, 127}, col: {0, 7}}, &move/2)
      end)
      |> Stream.map(fn %{col: {col, _}, row: {row, _}} ->
        (row * 8) + col
      end)
      |> Enum.sort()
    min = Enum.min(list)
    max = Enum.max(list)

    new_list =
      min..max
      |> Enum.to_list()
      |> Enum.reject(fn code -> code in list end)

    IO.inspect(new_list)
  end

  def move("F", %{row: {min, max}, col: col}) do
    %{row: calculate(min, max, :lower), col: col}
  end
  def move("B", %{row: {min, max}, col: col}) do
    %{row: calculate(min, max, :upper), col: col}
  end
  def move("L", %{row: row, col: {min, max}}) do
    %{row: row, col: calculate(min, max, :lower)}
  end
  def move("R", %{row: row, col: {min, max}}) do
    %{row: row, col: calculate(min, max, :upper)}
  end

  defp calculate(min, max, :lower), do: {min, div((max - min), 2) + min}
  defp calculate(min, max, :upper), do: {div((max - min) + 1, 2) + min, max}
end

# init in 127
# F - lowwer half
# B - Upper half


# BinaryBoarding.parse_input() |> IO.inspect()

BinaryBoarding.parse_input() |> BinaryBoarding.process()
