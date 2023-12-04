import gleeunit
import gleeunit/should
import day3

pub fn main() {
  gleeunit.main()
}

pub fn part_one_test() {
  day3.part_one(
    "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
",
  )
  |> should.equal(4361)
}

pub fn part_two_test() {
  day3.part_two(
    "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
",
  )
  |> should.equal(467_835)
}
