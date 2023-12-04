defmodule Day2 do
  @subset_limits %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  def run do
    IO.puts("=== Day 2 ===")

    IO.puts("Part One:")

    File.read!("day2.txt")
    |> part_one
    |> IO.puts()

    IO.puts("Part Two:")

    File.read!("day2.txt")
    |> part_two
    |> IO.puts()
  end

  def part_one(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      case Day2.Game.new(line) do
        {:ok, game} -> game
        {:error, error} -> raise(error)
      end
    end)
    |> Enum.filter(fn game ->
      game.rounds
      |> List.flatten()
      |> Enum.all?(fn subset ->
        subset.count <= @subset_limits[subset.color]
      end)
    end)
    |> Enum.map(& &1.id)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      case Day2.Game.new(line) do
        {:ok, game} -> game
        {:error, error} -> raise(error)
      end
    end)
    |> Enum.map(fn game ->
      game.rounds
      |> List.flatten()
      |> Enum.group_by(& &1.color, & &1.count)
      |> Enum.into([], fn {_color, counts} -> Enum.max(counts) end)
    end)
    |> Enum.map(&Enum.product(&1))
    |> Enum.sum()
  end
end

defmodule Day2.Game do
  alias Day2.Game.Parser
  alias Day2.Subset

  defstruct [:id, :rounds]

  def new(string) when is_binary(string) do
    case Parser.parse(string) do
      {:ok, results, "", _, _, _} ->
        {:ok,
         %__MODULE__{
           id: results[:id],
           rounds:
             Enum.map(results[:rounds], fn subset ->
               Enum.map(subset, &struct!(Subset, &1))
             end)
         }}

      {:error, reason, _, _, _, _} ->
        {:error, reason}
    end
  end
end

defmodule Day2.Subset do
  defstruct [:count, :color]
end

defmodule Day2.Game.Parser do
  import NimbleParsec

  color =
    choice([
      string("red"),
      string("green"),
      string("blue")
    ])
    |> unwrap_and_tag(:color)

  subset =
    ignore(optional(string(",")))
    |> ignore(optional(string(" ")))
    |> integer(min: 1)
    |> unwrap_and_tag(:count)
    |> ignore(string(" "))
    |> concat(color)
    |> wrap()

  round =
    ignore(string(" "))
    |> repeat(subset)
    |> ignore(optional(string(";")))
    |> wrap()

  game =
    ignore(string("Game"))
    |> ignore(string(" "))
    |> integer(min: 1)
    |> unwrap_and_tag(:id)
    |> ignore(string(":"))
    |> tag(repeat(round), :rounds)

  defparsec(:parse, game)
end

Day2.run()
