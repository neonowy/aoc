# 🎄 Advent of Code

My solutions for [Advent of Code](https://adventofcode.com) `{2023}`

## 2023

Going for a different language for each day.

| Day                                          | Status | Language                                        | Code                               |
| -------------------------------------------- | ------ | ----------------------------------------------- | ---------------------------------- |
| [Day 1](https://adventofcode.com/2023/day/1) | ⭐️⭐️ | [Rust](https://github.com/rust-lang/rust)       | [Source](2023/day1/src/day1.rs)    |
| [Day 2](https://adventofcode.com/2023/day/2) | ⭐️⭐️ | [Elixir](https://github.com/elixir-lang/elixir) | [Source](2023/day2/lib/day2.ex)    |
| [Day 3](https://adventofcode.com/2023/day/3) | ⭐️⭐️ | [Gleam](https://github.com/gleam-lang/gleam)    | [Source](2023/day3/src/day3.gleam) |
| [Day 4](https://adventofcode.com/2023/day/4) | ⭐️⭐️ | [F#](https://github.com/dotnet/fsharp/)         | [Source](2023/day4/Program.fs)     |

## How to run

I'm using [`nix`](https://nixos.org) with [`devenv`](https://devenv.sh) and [`direnv`](https://direnv.net) for automatically setting up different dependencies inside each day's directory.

If you have `nix` installed:

1. `cd` into directory for a given day.
2. Run `nix develop ../../.#day{REPLACE_WITH_DAY_NUMBER} --impure` (skip if you're using `direnv`).
3. `run-test` to run tests.
4. `run` to run the program.
