import std/rationals

type Expression* = object
  ## A node with a cached value. Children index the same node sequence.
  evaluated: Rational[int]
  operator: char
  left, right: int

func literal*(number: int): Expression =
  Expression(evaluated: number // 1)

func value*(expression: Expression): Rational[int] =
  expression.evaluated

func combine*(nodes: openArray[Expression], left, right: int,
    operator: char): Expression =
  ## Build a binary node referring to existing children in nodes.
  case operator
  of '+': result.evaluated = nodes[left].value + nodes[right].value
  of '-': result.evaluated = nodes[left].value - nodes[right].value
  of '*': result.evaluated = nodes[left].value * nodes[right].value
  of '/':
    if nodes[right].value.num == 0:
      raise newException(ValueError, "Cannot divide by zero.")
    result.evaluated = nodes[left].value / nodes[right].value
  else:
    raise newException(ValueError, "Unknown operator.")
  result.operator = operator
  result.left = left
  result.right = right

func appendExpression(nodes: openArray[Expression], index: int, text: var string) =
  if nodes[index].operator == '\0':
    text.add($nodes[index].value.num)
    return
  text.add('(')
  nodes.appendExpression(nodes[index].left, text)
  text.add(nodes[index].operator)
  nodes.appendExpression(nodes[index].right, text)
  text.add(')')

func toString*(nodes: openArray[Expression], root: int): string =
  ## Render a node and its children as a fully parenthesized expression.
  nodes.appendExpression(root, result)
