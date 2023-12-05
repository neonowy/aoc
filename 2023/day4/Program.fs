open System.Text.RegularExpressions
open System.Diagnostics

type ScratchingCard =
    { Number: int
      WinningNumbers: Set<int>
      MyNumbers: Set<int> }

let flip f x y = f y x
let split (separator: char) (string: string) : string[] = string.Split(separator)

let readString path = System.IO.File.ReadAllText path

let (|ParseRegex|_|) regex str =
    let m = Regex(regex).Match(str)

    if m.Success then
        Some(List.tail [ for x in m.Groups -> x.Value ])
    else
        None

let (|Integer|_|) (str: string) =
    let mutable intvalue = 0

    if System.Int32.TryParse(str, &intvalue) then
        Some(intvalue)
    else
        None

let (|WhitespaceSeparatedNumbers|_|) (str: string) =
    str
    |> split ' '
    |> Array.choose (fun x ->
        match x with
        | Integer i -> Some(i)
        | _ -> None)
    |> Option.Some

let readScratchingCard line : ScratchingCard =
    match line with
    | ParseRegex "Card\s*(\d+):\s*(.+)\s*\|\s*(.+)\s*$" [ Integer cardNumber
                                                          WhitespaceSeparatedNumbers winningNumbers
                                                          WhitespaceSeparatedNumbers myNumbers ] ->
        { Number = cardNumber
          WinningNumbers = winningNumbers |> Set.ofArray
          MyNumbers = myNumbers |> Set.ofArray }
    | _ -> invalidArg line "Invalid card format"

let readScratchingCards input =
    input |> split '\n' |> Array.map (readScratchingCard)

let findMyWinningNumbers (card: ScratchingCard) : Set<int> =
    Set.intersect card.WinningNumbers card.MyNumbers

let cardPoints (card: ScratchingCard) : int =
    let myWinningNumbersCount = findMyWinningNumbers (card) |> Set.count
    pown 2 (myWinningNumbersCount - 1)

let rec cardWithCopies (card: ScratchingCard) (cards: ScratchingCard[]) : List<ScratchingCard> =
    let myWinningNumbersCount = findMyWinningNumbers (card) |> Set.count

    let copies =
        List.init myWinningNumbersCount (fun x -> card.Number + x + 1)
        |> List.choose (fun cardNumber -> cards |> Array.tryFind (fun c -> c.Number = cardNumber))
        |> List.collect (fun cardCopy -> cardWithCopies cardCopy cards)

    card :: copies


let partOne (input: string) =
    input |> readScratchingCards |> Array.sumBy (cardPoints)

let partTwo (input: string) =
    let cards = input |> readScratchingCards

    cards
    |> Array.map (flip cardWithCopies cards)
    |> Array.collect (List.toArray)
    |> Array.length

Debug.Assert(
    (partOne (
        "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
    ) = 13),
    "Part One example assert failed"
)

Debug.Assert(
    (partTwo (
        "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
    ) = 30),
    "Part Two example assert failed"
)

printfn "=== Day 4 ==="

let input = readString "day4.txt"

input |> partOne |> printfn "Part One:\n%d"
input |> partTwo |> printfn "Part Two:\n%d"
