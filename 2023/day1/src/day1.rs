use phf::phf_map;

pub fn part_one(input: &str) -> u32 {
    input
        .lines()
        .map(|line| {
            let digits = line
                .chars()
                .filter_map(|char| char.to_digit(10))
                .collect::<Vec<u32>>();

            let first_digit = digits.first().unwrap();
            let last_digit = digits.last().unwrap();

            10 * first_digit + last_digit
        })
        .sum()
}

pub fn part_two(input: &str) -> u32 {
    input
        .lines()
        .map(|line| {
            let mut digits = Vec::<u32>::new();

            for start_idx in 0..line.len() {
                for (digit_str, digit) in DIGITS_BY_STRING.into_iter() {
                    if line[start_idx..].starts_with(digit_str) {
                        digits.push(*digit);
                    }
                }
            }

            let first_digit = digits.first().unwrap();
            let last_digit = digits.last().unwrap();

            10 * first_digit + last_digit
        })
        .sum()
}

static DIGITS_BY_STRING: phf::Map<&'static str, u32> = phf_map! {
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
};

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        assert_eq!(
            part_one(
                "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"
            ),
            142
        )
    }

    #[test]
    fn test_part_two() {
        assert_eq!(
            part_two(
                "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"
            ),
            281
        )
    }
}
