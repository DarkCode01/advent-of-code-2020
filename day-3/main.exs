defmodule TobogganTrajectory do
  @file_path "./input.txt"

  def parse_input do
    File.read!(@file_path)
    |> String.split("\n", trim: true)
    |> Enum.map(& String.split(&1, "", trim: true))
  end

  def calculate(map, {coorR, coorD}, {pos, sub_pos}, trees) do
    try do
      pos = pos + coorD
      sub_pos = sub_pos + coorR

      # count length of current column to expand
      column = Enum.at(map, pos)
      length = Enum.count(column)
      counted = div(sub_pos, length)

      column =
        column
        |> List.duplicate(counted)
        |> List.flatten()
        |> Enum.concat(column)

      # verify if ist a tree
      trees? = if(Enum.at(column, sub_pos) == "#", do: "X", else: "0")
      column = List.replace_at(column, sub_pos, trees?)

      # update map
      map = List.replace_at(map, pos, column)

      # recursion
      calculate(
        map,
        {coorR, coorD},
        {pos, sub_pos},
        if(trees? == "X", do: trees + 1, else: trees)
      )
    rescue
       _ -> trees
    end
  end
end

input = TobogganTrajectory.parse_input()

p1 = TobogganTrajectory.calculate(input, {1, 1}, {0, 0}, 0)
p2 = TobogganTrajectory.calculate(input, {3, 1}, {0, 0}, 0)
p3 = TobogganTrajectory.calculate(input, {5, 1}, {0, 0}, 0)
p4 = TobogganTrajectory.calculate(input, {7, 1}, {0, 0}, 0)
p5 = TobogganTrajectory.calculate(input, {1, 2}, {0, 0}, 0)

IO.inspect("P1 = #{p1}")
IO.inspect("P2 = #{p2}")
IO.inspect("P3 = #{p3}")
IO.inspect("P4 = #{p4}")
IO.inspect("P5 = #{p5}")

IO.inspect("Total trees: #{p1 * p2 * p3 * p4 * p5}")


# |> Enum.map(& Enum.join(&1, " "))\
# |> Enum.each(&IO.inspect/1)

# t = TobogganTrajectory.parse_input()
# c = Enum.at(t, 0)
# c = List.replace_at(c, 2, "0")
# t = List.replace_at(t, 0, c)

# IO.inspect(t)
