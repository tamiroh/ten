import std/[rationals, sets]
import expression

type Candidate = object
  expression: Expression
  value: Rational[int]

func calculate(left, right: Rational[int], operator: Operator): Rational[int] =
  case operator
  of opAdd: return left + right
  of opSubtract: return left - right
  of opMultiply: return left * right
  of opDivide: return left / right

func findSolutions*(digits: array[4, int]): seq[Expression] =
  ## Return all structurally distinct binary arithmetic expressions
  ## that use the supplied digits exactly once and evaluate to 10.
  ## Operand orders and parenthesizations remain distinct.
  # Cache intermediate values for the search, separately from expression trees.
  var expressions: array[16, seq[Candidate]]
  for index, digit in digits:
    if digit notin 0..9:
      raise newException(ValueError, "Puzzle digits must be between 0 and 9.")
    expressions[1 shl index] = @[Candidate(expression: literal(digit), value: digit // 1)]

  # Bits identify digit positions, so repeated digits can be used separately.
  for subset in 1..15:
    var leftSubset = (subset - 1) and subset
    while leftSubset > 0:
      let rightSubset = subset xor leftSubset
      for left in expressions[leftSubset]:
        for right in expressions[rightSubset]:
          for operator in Operator:
            if operator == opDivide and right.value.num == 0:
              continue
            let value = calculate(left.value, right.value, operator)
            if subset == 15 and value != 10 // 1:
              continue
            expressions[subset].add(Candidate(
              expression: combine(left.expression, right.expression, operator), value: value))
      leftSubset = (leftSubset - 1) and subset

  var solutions = initHashSet[Expression]()
  for candidate in expressions[15]:
    if not solutions.containsOrIncl(candidate.expression):
      result.add(candidate.expression)
