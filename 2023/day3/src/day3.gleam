import gleam/io
import gleam/string
import gleam/iterator
import gleam/int
import gleam/list
import gleam/result
import gleam/bool
import gleam/dict.{type Dict}
import gleam/erlang/file

pub fn main() {
  io.println("=== Day 3 ===")

  let assert Ok(input) = file.read("day3.txt")

  io.println("Part One:")
  part_one(input)
  |> int.to_string
  |> io.println

  io.println("Part Two:")
  part_two(input)
  |> int.to_string
  |> io.println
}

pub fn part_one(input: String) -> Int {
  let rows =
    input
    |> string.split(on: "\n")
    |> iterator.from_list
    |> iterator.map(string.to_graphemes)
    |> iterator.to_list

  let part_numbers = find_part_numbers(rows)

  part_numbers
  |> list.map(fn(part_number) { part_number.number })
  |> list.filter_map(int.parse)
  |> list.fold(0, int.add)
}

pub fn part_two(input: String) -> Int {
  let rows =
    input
    |> string.split(on: "\n")
    |> iterator.from_list
    |> iterator.map(string.to_graphemes)
    |> iterator.to_list

  let part_numbers = find_part_numbers(schematic: rows)
  let part_numbers_by_symbols = group_part_numbers_by_symbol(part_numbers)

  let gears =
    part_numbers_by_symbols
    // filters only symbols adjacent to exactly two part numbers
    |> dict.filter(fn(_, part_numbers) { list.length(part_numbers) == 2 })

  let gear_ratios =
    gears
    |> dict.values
    |> list.map(fn(part_numbers) {
      part_numbers
      |> list.map(fn(part_number) { part_number.number })
      |> list.filter_map(int.parse)
      |> int.product
    })

  gear_ratios
  |> list.fold(0, int.add)
}

fn group_part_numbers_by_symbol(
  part_numbers: List(PartNumber),
) -> Dict(Point, List(PartNumber)) {
  part_numbers
  |> list.fold(
    dict.new(),
    fn(symbols_dict, part_number) {
      part_number.adjacent_symbols
      |> list.fold(
        symbols_dict,
        fn(part_symbols_dict, symbol) {
          case
            part_symbols_dict
            |> dict.get(symbol)
          {
            Ok(part_numbers) ->
              part_numbers
              |> list.prepend(part_number)
              |> dict.insert(part_symbols_dict, symbol, _)
            Error(_) -> dict.insert(part_symbols_dict, symbol, [part_number])
          }
        },
      )
    },
  )
}

fn find_part_numbers(schematic rows: List(List(String))) -> List(PartNumber) {
  rows
  |> list.index_fold(
    [],
    fn(part_numbers, row, x) {
      row
      |> list.index_fold(
        [PartNumber(number: "", adjacent_symbols: [])],
        fn(part_numbers, char, y) {
          // In the following example,
          // `x` is adjacent to all the star symbols:
          // * * *
          // * x *
          // * * *

          let adjacent_symbols =
            [
              Point(x: x - 1, y: y - 1),
              Point(x: x - 1, y: y),
              Point(x: x - 1, y: y + 1),
              Point(x: x, y: y - 1),
              Point(x: x, y: y + 1),
              Point(x: x + 1, y: y - 1),
              Point(x: x + 1, y: y),
              Point(x: x + 1, y: y + 1),
            ]
            |> list.filter(fn(point) {
              at(rows, point.x, point.y)
              |> result.map(is_a_symbol)
              |> result.unwrap(False)
            })

          case int.parse(char), part_numbers {
            // it's the first digit for a new number
            Ok(_), [PartNumber("", ..), ..rest] -> [
              PartNumber(char, adjacent_symbols),
              ..rest
            ]

            // it's a new digit for an existing number
            Ok(_), [PartNumber(prev_chars, prev_adjacent_symbols), ..rest] -> [
              PartNumber(
                prev_chars <> char,
                adjacent_symbols
                |> list.append(prev_adjacent_symbols)
                |> list.unique,
              ),
              ..rest
            ]

            // it's not a digit, and we've already created an empty element for the next number
            Error(_), [PartNumber("", _), ..rest] -> [
              PartNumber("", []),
              ..rest
            ]

            // it's not a digit, and we have to create an empty element for the next number
            Error(_), [last, ..rest] -> [PartNumber("", []), last, ..rest]
          }
        },
      )
      |> list.reverse
      // filters only symbol adjacent numbers
      |> list.filter(fn(part_number) {
        part_number.adjacent_symbols
        |> list.is_empty
        |> bool.negate
      })
      |> list.append(part_numbers, _)
    },
  )
}

// stores 2d array coordinates
type Point {
  Point(x: Int, y: Int)
}

type PartNumber {
  PartNumber(
    // part number
    number: String,
    // coordinates of symbols adjacent to any of the part number digits
    adjacent_symbols: List(Point),
  )
}

fn at(
  in list: List(List(a)),
  x row_index: Int,
  y column_index: Int,
) -> Result(a, Nil) {
  case list.at(list, row_index) {
    Ok(row) -> list.at(row, column_index)
    Error(error) -> Error(error)
  }
}

fn is_a_symbol(char: String) -> Bool {
  case char, int.parse(char) {
    // it's a digit
    _, Ok(_) -> False

    // it's a dot
    ".", _ -> False

    // else it's a symbol!
    _, _ -> True
  }
}
