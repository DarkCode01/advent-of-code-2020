defmodule PasswordPhilosophy do
  @file_path "./input.txt"

  def parse_input do
    File.read!(@file_path)
    |> String.split("\n", trim: true)
    |> Enum.map(& String.split(&1, ":", trim: true))
  end

  def verify_password([], count), do: count
  # def verify_password([[policy, pass] | []], count), do: _
  def verify_password([[policy, pass] | tail], count) do
    verify_password(tail, process_count(policy, pass, count))
  end

  defp process_count(policy, pass, count) do
    [min, max] =
      Regex.scan(~r/[0-9]+/, policy)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    # counted = process_count(policy, pass)
    pass = String.split(pass, "", trim: true)
    letter = Regex.scan(~r/[A-Za-z]+/, policy) |> List.flatten() |> hd
    # counted = Enum.count(pass, & &1 == letter)

    fpos = Enum.at(pass, min)
    lpos = Enum.at(pass, max)

    if (fpos == letter and lpos == letter) or (fpos != letter and lpos != letter) do
      count
    else
      count + 1
    end
  end
end

PasswordPhilosophy.parse_input() |> PasswordPhilosophy.verify_password(0) |> IO.inspect()
# PasswordPhilosophy.verify_password([["1-3 a", " abcde"], ["1-3 b", " cdefg"]], 0)
