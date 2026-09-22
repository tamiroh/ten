import std/rationals

type Parser = object
  input: string
  position: int

func peek(parser: var Parser): char =
  while parser.position < parser.input.len and
      parser.input[parser.position] in {' ', '\t', '\r', '\n'}:
    inc parser.position
  if parser.position == parser.input.len:
    return '\0'
  return parser.input[parser.position]

func expression(parser: var Parser): Rational[int]

func factor(parser: var Parser): Rational[int] =
  case parser.peek()
  of '0'..'9':
    let digit = ord(parser.input[parser.position]) - ord('0')
    inc parser.position
    return digit // 1
  of '(':
    inc parser.position
    result = parser.expression()
    if parser.peek() != ')':
      raise newException(ValueError, "Expected a closing parenthesis.")
    inc parser.position
  of '+', '-':
    let negative = parser.peek() == '-'
    inc parser.position
    result = parser.factor()
    if negative:
      result = -result
  else:
    raise newException(ValueError, "Expected a digit or an opening parenthesis.")

func term(parser: var Parser): Rational[int] =
  result = parser.factor()
  while parser.peek() in {'*', '/'}:
    let operator = parser.peek()
    inc parser.position
    let right = parser.factor()
    if operator == '*':
      result = result * right
    else:
      if right.num == 0:
        raise newException(ValueError, "Cannot divide by zero.")
      result = result / right

func expression(parser: var Parser): Rational[int] =
  result = parser.term()
  while parser.peek() in {'+', '-'}:
    let operator = parser.peek()
    inc parser.position
    let right = parser.term()
    if operator == '+':
      result = result + right
    else:
      result = result - right

func evaluate*(input: string): Rational[int] =
  ## Evaluate single-digit arithmetic with parentheses and unary signs.
  if input.len > 256:
    raise newException(ValueError, "Keep the expression within 256 characters.")
  var parser = Parser(input: input)
  result = parser.expression()
  if parser.peek() != '\0' or parser.position != input.len:
    raise newException(ValueError, "Use only single digits, + - * /, and parentheses.")
