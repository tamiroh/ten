import std/[algorithm, rationals, sets]
import expression

func findSolutions*(digits: array[4, int]): seq[string] =
  ## Return all distinct, fully parenthesized binary arithmetic expressions
  ## that use the supplied digits exactly once and evaluate to 10.
  ## Results are sorted. Operand orders and parenthesizations remain distinct.
  # Nodes share subexpressions by index, without allocating a string per node.
  var nodes: seq[Expression]
  var expressions: array[16, seq[int]]
  for index, digit in digits:
    if digit notin 0..9:
      raise newException(ValueError, "Puzzle digits must be between 0 and 9.")
    expressions[1 shl index] = @[nodes.len]
    nodes.add(literal(digit))

  # Bits identify digit positions, so repeated digits can be used separately.
  for subset in 1..15:
    var leftSubset = (subset - 1) and subset
    while leftSubset > 0:
      let rightSubset = subset xor leftSubset
      for left in expressions[leftSubset]:
        for right in expressions[rightSubset]:
          for operator in ['+', '-', '*', '/']:
            if operator == '/' and nodes[right].value.num == 0:
              continue
            let candidate = nodes.combine(left, right, operator)
            if subset == 15 and candidate.value != 10 // 1:
              continue
            expressions[subset].add(nodes.len)
            nodes.add(candidate)
      leftSubset = (leftSubset - 1) and subset

  var solutions: HashSet[string]
  for index in expressions[15]:
    solutions.incl(nodes.toString(index))
  for solution in solutions:
    result.add(solution)
  result.sort()
