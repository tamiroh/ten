import std/[algorithm, math, rationals, sequtils, strutils, tables]
import expression

const
  fractionCost = 3
  negativeCost = 2
  divisionCost = 1
  largeValueCost = 1
  largeValueLimit = 20

type Level* = enum
  levelEasy = "Easy"
  levelNormal = "Normal"
  levelHard = "Hard"
  levelExpert = "Expert"

func calculate(left, right: Rational[int], operator: Operator): Rational[int] =
  case operator
  of opAdd: return left + right
  of opSubtract: return left - right
  of opMultiply: return left * right
  of opDivide: return left / right

func walk(expression: Expression, cost: var int): Rational[int] =
  ## Evaluate the expression while adding costs for steps that people find hard.
  if expression.isLiteral:
    return expression.number // 1
  result = calculate(expression.left.walk(cost), expression.right.walk(cost),
    expression.operator)
  if expression.operator == opDivide:
    cost += divisionCost
  if result.den != 1:
    cost += fractionCost
  if result < 0 // 1:
    cost += negativeCost
  if abs(result) > largeValueLimit // 1:
    cost += largeValueCost

func solutionCost*(expression: Expression): int =
  ## Return how hard a single solution is to find. Simple chains of
  ## integer additions and multiplications cost nothing.
  discard expression.walk(result)

func isAdditive(operator: Operator): bool =
  operator in {opAdd, opSubtract}

func canonical(expression: Expression): string

func collectTerms(expression: Expression, additive, inverted: bool,
    terms, inverses: var seq[string]) =
  ## Flatten a chain of `+ -` or `* /` into the terms on each side.
  if expression.isLiteral or expression.operator.isAdditive != additive:
    if inverted:
      inverses.add(expression.canonical)
    else:
      terms.add(expression.canonical)
    return
  expression.left.collectTerms(additive, inverted, terms, inverses)
  expression.right.collectTerms(additive,
    inverted xor expression.operator in {opSubtract, opDivide}, terms, inverses)

func canonical(expression: Expression): string =
  ## Render the expression so that reordering commutative and associative
  ## operands, such as `1+2+3+4` and `4+(3+2)+1`, gives the same text.
  if expression.isLiteral:
    return $expression.number
  let additive = expression.operator.isAdditive
  var terms, inverses: seq[string]
  expression.collectTerms(additive, false, terms, inverses)
  let (join, inverse) = if additive: ("+", "-") else: ("*", "/")
  result = "(" & terms.sorted.join(join)
  for term in inverses.sorted:
    result.add(inverse & term)
  result.add(")")

func distinctSolutions*(solutions: openArray[Expression]): seq[Expression] =
  ## Keep the easiest expression for each solution that differs only in
  ## operand order or grouping of commutative operators.
  var indices = initTable[string, int]()
  for solution in solutions:
    let key = solution.canonical
    if key notin indices:
      indices[key] = result.len
      result.add(solution)
    elif solution.solutionCost < result[indices[key]].solutionCost:
      result[indices[key]] = solution

func difficulty*(solutions: openArray[Expression]): float =
  ## Score a puzzle by its easiest solution, made easier when several
  ## distinct solutions are equally easy.
  if solutions.len == 0:
    raise newException(ValueError, "A puzzle needs at least one solution.")
  let costs = solutions.distinctSolutions.mapIt(it.solutionCost)
  let easiest = costs.min
  return float(easiest) - ln(float(costs.count(easiest)))

func level*(difficulty: float): Level =
  ## Group scores into levels split at the gaps in the score distribution.
  ## Expert puzzles need fractions, and hard ones need division, negatives
  ## or large intermediate values.
  if difficulty < -1: levelEasy
  elif difficulty < 1: levelNormal
  elif difficulty < 7: levelHard
  else: levelExpert

func parseLevel*(name: string): Level =
  for level in Level:
    if cmpIgnoreCase(name, $level) == 0:
      return level
  raise newException(ValueError, "Unknown level. Choose easy, normal, hard or expert.")
