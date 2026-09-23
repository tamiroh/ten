{.experimental: "notnil".}

import std/hashes

type
  Operator* = enum
    opAdd = "+"
    opSubtract = "-"
    opMultiply = "*"
    opDivide = "/"

  ExpressionKind = enum
    literalExpression, binaryExpression

  Expression* = ref ExpressionNode not nil

  ExpressionNode = object
    case kind: ExpressionKind
    of literalExpression:
      number: int
    of binaryExpression:
      operator: Operator
      left, right: Expression

func literal*(number: int): Expression =
  Expression(kind: literalExpression, number: number)

func combine*(left, right: Expression, operator: Operator): Expression =
  return Expression(kind: binaryExpression, operator: operator, left: left, right: right)

func `==`*(left, right: Expression): bool =
  if left.kind != right.kind:
    return false
  case left.kind
  of literalExpression:
    return left.number == right.number
  of binaryExpression:
    return left.operator == right.operator and left.left == right.left and
      left.right == right.right

func hash*(expression: Expression): Hash =
  result = hash(expression.kind)
  case expression.kind
  of literalExpression:
    result = result !& hash(expression.number)
  of binaryExpression:
    result = result !& hash(expression.operator)
    result = result !& hash(expression.left)
    result = result !& hash(expression.right)
  result = !$result

func appendExpression(expression: Expression, text: var string) =
  case expression.kind
  of literalExpression:
    text.add($expression.number)
  of binaryExpression:
    text.add('(')
    expression.left.appendExpression(text)
    text.add($expression.operator)
    expression.right.appendExpression(text)
    text.add(')')

func toString*(expression: Expression): string =
  ## Render the recursive expression as a fully parenthesized string.
  expression.appendExpression(result)
