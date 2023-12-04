use std::{fs::File, io::Read};

mod day1;

fn main() {
    println!("=== Day 1 ===");

    let mut day1_input = String::new();

    File::open("day1.txt")
        .unwrap()
        .read_to_string(&mut day1_input)
        .unwrap();

    println!("Part One:\n{:?}", day1::part_one(&day1_input));
    println!("Part Two:\n{:?}", day1::part_two(&day1_input));
}
