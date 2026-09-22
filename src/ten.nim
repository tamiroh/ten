import std/[random, rationals, strutils]
import ten/[answer, prompt, solver]

proc newPuzzle(): array[4, int] =
  while true:
    for digit in result.mitems:
      digit = rand(9)
    if findSolutions(result).len > 0:
      return

proc showPuzzle(digits: array[4, int]) =
  echo "\nDigits: ", digits.join(" ")

proc main() =
  randomize()
  echo "10 puzzle"
  echo "Use all four digits exactly once with + - * / and parentheses to make 10."
  echo "No concatenation. Every puzzle has a solution."
  echo "answers: show all solutions / next: skip / quit: exit"
  var digits = newPuzzle()
  showPuzzle(digits)
  while true:
    var line: string
    if not readPrompt(line):
      echo ""
      break
    case line.strip.toLowerAscii
    of "quit", "q":
      break
    of "next", "n":
      digits = newPuzzle()
      showPuzzle(digits)
    of "answers", "a":
      let solutions = findSolutions(digits)
      echo "Solutions: ", solutions.len
      for solution in solutions:
        echo solution, " = 10"
    of "":
      discard
    else:
      try:
        let value = evaluateAnswer(line, digits)
        if value == 10 // 1:
          echo "Correct!"
          digits = newPuzzle()
          showPuzzle(digits)
        else:
          echo "Result: ", (if value.den == 1: $value.num else: $value), ". Try again!"
      except ValueError as error:
        echo error.msg

when isMainModule:
  main()
