import std/[algorithm, rationals, sets]

type Expression = object
  value: Rational[int]
  text: string

func combine(left, right: Expression, operator: char): Expression =
  case operator
  of '+': result.value = left.value + right.value
  of '-': result.value = left.value - right.value
  of '*': result.value = left.value * right.value
  of '/': result.value = left.value / right.value
  else: raise newException(ValueError, "Unknown operator.")
  result.text = "(" & left.text & $operator & right.text & ")"

func findSolutions*(digits: array[4, int]): seq[string] =
  ## Return all distinct, fully parenthesized binary arithmetic expressions
  ## that use the supplied digits exactly once and evaluate to 10.
  ## Results are sorted. Operand orders and parenthesizations remain distinct.
  var expressions: array[16, seq[Expression]]
  for index, digit in digits:
    if digit notin 0..9:
      raise newException(ValueError, "Puzzle digits must be between 0 and 9.")
    expressions[1 shl index] = @[Expression(value: digit // 1, text: $digit)]

  # Bits identify digit positions, so repeated digits can be used separately.
  for subset in 1..15:
    var leftSubset = (subset - 1) and subset
    while leftSubset > 0:
      let rightSubset = subset xor leftSubset
      for left in expressions[leftSubset]:
        for right in expressions[rightSubset]:
          for operator in ['+', '-', '*', '/']:
            if operator == '/' and right.value.num == 0:
              continue
            expressions[subset].add(combine(left, right, operator))
      leftSubset = (leftSubset - 1) and subset

  var solutions: HashSet[string]
  for expression in expressions[15]:
    if expression.value == 10 // 1:
      solutions.incl(expression.text)
  for solution in solutions:
    result.add(solution)
  result.sort()
