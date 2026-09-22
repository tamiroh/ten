{.experimental: "notnil".}

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
