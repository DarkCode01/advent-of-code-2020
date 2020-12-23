defmodule PassportProcessing do
  @file_path "./input.txt"

  @ecolors ~w(amb blu brn gry grn hzl oth)

  def parse_input do
    File.read!(@file_path)
    |> String.split("\n")
    |> Enum.chunk_by(& &1 != "")
    |> Enum.map(& Enum.join(&1, " "))
    |> Enum.filter(& &1 != "")
    |> Enum.map(& String.split(&1, " "))
  end


  def validate_passports(passports) do
    do_validate_passports(passports, 0)
  end

  defp do_validate_passports([], result), do: "Validos: #{result}"
  defp do_validate_passports([passport | tail], result) do
    passport = Enum.reduce(
      passport,
      %{},
      fn x, p -> add_value(p, x) end
    )
    valid? = valid?(passport)

    do_validate_passports(
      tail,
      if(valid?, do: result + 1, else: result)
    )
  end

  def valid?(%{ecl: ecl, eyr: eyr, hcl: hcl, hgt: hgt, iyr: iyr, pid: pid, byr: byr}) do
    pid? = validate_pid(pid)
    hgt? = validate_heigth(hgt)
    hcl? = validate_hcolor(hcl)
    ecl? = validate_ecolor(ecl)
    byr? = validate_year(byr, {1920, 2003})
    iyr? = validate_year(iyr, {2010, 2020})
    eyr? = validate_year(eyr, {2020, 2030})

    Enum.all?([pid?, hgt?, hcl?, ecl?, byr?, iyr?, eyr?])
  end

  def valid?(_), do: false

  def validate_year(value, {min, max}) do
    length = String.length(value)
    n = String.to_integer(value)

    length == 4 and n >= min and n <= max
  end

  def validate_heigth(value) do
    regex = Regex.scan(~r/^[0-9]+|[cm|in]{2}$/, value)
    [number] = hd(regex)
    type = tl(regex) |> Enum.join("")
    number = String.to_integer(number)

    case type do
      "cm" -> number >= 150 and number <= 193
      "in" -> number >= 59 and number <= 76
      _ -> false
    end
  end

  def validate_hcolor(value) do
    Regex.match?(~r/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/, value)
  end

  def validate_ecolor(value), do: value in @ecolors

  def validate_pid(value), do: Regex.match?(~r/^[0-9]{9}$/, value)

  defp add_value(passport, "ecl:" <> value) do
    Map.merge(passport, %{ecl: value})
  end
  defp add_value(passport, "pid:" <> value) do
    Map.merge(passport, %{pid: value})
  end
  defp add_value(passport, "eyr:" <> value) do
    Map.merge(passport, %{eyr: value})
  end
  defp add_value(passport, "hcl:" <> value) do
    Map.merge(passport, %{hcl: value})
  end
  defp add_value(passport, "byr:" <> value) do
    Map.merge(passport, %{byr: value})
  end
  defp add_value(passport, "iyr:" <> value) do
    Map.merge(passport, %{iyr: value})
  end
  defp add_value(passport, "hgt:" <> value) do
    Map.merge(passport, %{hgt: value})
  end
  defp add_value(passport, "cid:" <> value) do
    Map.merge(passport, %{cid: value})
  end

end

PassportProcessing.parse_input()
|> PassportProcessing.validate_passports()
|> IO.inspect()

# PassportProcessing.get_value("ecl:caca") |> IO.inspect()
