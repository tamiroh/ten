import std/unittest
import ../src/ten/[difficulty, expression, solver]

suite "Puzzle difficulty":
  test "integer additions cost nothing while fractions and negatives cost more":
    let sum = combine(combine(literal(1), literal(2), opAdd), literal(7), opAdd)
    let negative = combine(combine(literal(2), literal(5), opSubtract), literal(7), opAdd)
    let fraction = combine(combine(literal(1), literal(5), opDivide), literal(5), opMultiply)
    check sum.solutionCost == 0
    check negative.solutionCost > sum.solutionCost
    check fraction.solutionCost > negative.solutionCost

  test "reordered operands count as one solution":
    let solutions = findSolutions([1, 2, 3, 4])
    check solutions.distinctSolutions.len < solutions.len
    check findSolutions([4, 3, 2, 1]).distinctSolutions.len ==
      solutions.distinctSolutions.len

  test "the easiest ordering of a solution is used":
    # (8-9)+8+3 goes negative, but 8+8+3-9 is the same solution without it.
    check difficulty(findSolutions([3, 8, 8, 9])) <= 0

  test "puzzles that need fractions are the hardest":
    for hard in [[1, 1, 5, 8], [1, 1, 9, 9], [3, 4, 7, 8]]:
      for easy in [[1, 2, 3, 4], [8, 8, 8, 8], [9, 9, 9, 9]]:
        check difficulty(findSolutions(hard)) > difficulty(findSolutions(easy))

  test "levels range from easy puzzles to ones that need fractions":
    check difficulty(findSolutions([0, 0, 2, 5])).level == levelEasy
    check difficulty(findSolutions([3, 5, 7, 9])).level == levelNormal
    check difficulty(findSolutions([9, 9, 9, 9])).level == levelHard
    for digits in [[1, 1, 5, 8], [1, 1, 9, 9], [1, 3, 3, 7], [3, 4, 7, 8]]:
      check difficulty(findSolutions(digits)).level == levelExpert

  test "levels are parsed regardless of case":
    check parseLevel("hard") == levelHard
    check parseLevel("Expert") == levelExpert
    expect ValueError:
      discard parseLevel("impossible")

  test "puzzles without solutions are rejected":
    expect ValueError:
      discard difficulty(findSolutions([1, 1, 1, 1]))
