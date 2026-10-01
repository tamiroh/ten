import std/[algorithm, random, rationals, sequtils, strutils]
import ten/[answer, difficulty, expression, prompt, solver]

type Puzzle = object
  digits: array[4, int]
  solutions: seq[Expression]

proc newPuzzle(level: Level): Puzzle =
  while true:
    for digit in result.digits.mitems:
      digit = rand(9)
    result.solutions = findSolutions(result.digits)
    if result.solutions.len > 0 and difficulty(result.solutions).level == level:
      return

proc showPuzzle(puzzle: Puzzle) =
  echo "\nDigits: ", puzzle.digits.join(" ")
  echo "Difficulty: ", difficulty(puzzle.solutions).level

proc main() =
  randomize()
  echo "10 puzzle"
  echo "Use all four digits exactly once with + - * / and parentheses to make 10."
  echo "No concatenation or unary signs. Every puzzle has a solution."
  echo "answers: show all solutions / next: skip / level <name>: change level / quit: exit"
  var level = levelNormal
  var puzzle = newPuzzle(level)
  showPuzzle(puzzle)
  while true:
    var line: string
    if not readPrompt(line):
      echo ""
      break
    let words = line.toLowerAscii.splitWhitespace
    case (if words.len > 0: words[0] else: "")
    of "quit", "q":
      break
    of "next", "n":
      puzzle = newPuzzle(level)
      showPuzzle(puzzle)
    of "answers", "a":
      echo "Solutions: ", puzzle.solutions.len
      for solution in puzzle.solutions.mapIt($it).sorted:
        echo solution, " = 10"
    of "level", "l":
      if words.len == 1:
        echo "Level: ", level
        echo "Levels: ", Level.toSeq.join(", ")
        continue
      try:
        level = parseLevel(words[1])
        puzzle = newPuzzle(level)
        showPuzzle(puzzle)
      except ValueError as error:
        echo error.msg
    of "":
      discard
    else:
      try:
        let value = evaluateAnswer(line, puzzle.digits)
        if value == 10 // 1:
          echo "Correct!"
          puzzle = newPuzzle(level)
          showPuzzle(puzzle)
        else:
          echo "Result: ", (if value.den == 1: $value.num else: $value), ". Try again!"
      except ValueError as error:
        echo error.msg

when isMainModule:
  main()
