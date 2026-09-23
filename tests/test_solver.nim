import std/[algorithm, rationals, sequtils, sets, unittest]
import ../src/ten/[answer, expression, solver]

suite "Puzzle solutions":
  test "known solutions with different expression shapes":
    for puzzle in [
        ([1, 2, 3, 4], "(((1+2)+3)+4)"),
        ([6, 1, 1, 1], "((6-1)*(1+1))"),
        ([1, 1, 2, 6], "((6-1)*(1*2))"),
        ([8, 1, 1, 5], "(8/(1-(1/5)))")]:
      check puzzle[1] in findSolutions(puzzle[0]).mapIt(it.toString())

  test "all returned solutions satisfy the game rules":
    for digits in [[1, 2, 3, 4], [0, 1, 3, 3], [0, 0, 5, 5], [8, 1, 1, 5]]:
      let solutions = findSolutions(digits)
      check solutions.len > 0
      check solutions.len == solutions.toHashSet.len
      for solution in solutions:
        check evaluateAnswer(solution.toString(), digits) == 10 // 1

  test "operand orders and parentheses remain distinct":
    let solutions = findSolutions([1, 2, 3, 4]).mapIt(it.toString()).sorted
    check "(((1+2)+3)+4)" in solutions
    check "(((2+1)+3)+4)" in solutions
    check "((1+2)+(3+4))" in solutions
    check solutions == findSolutions([4, 3, 2, 1]).mapIt(it.toString()).sorted

  test "unsolvable puzzles return an empty sequence":
    for digits in [[0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 9]]:
      check findSolutions(digits).len == 0

  test "invalid digits are rejected":
    for digits in [[-1, 2, 3, 4], [10, 2, 3, 4]]:
      expect ValueError:
        discard findSolutions(digits)
