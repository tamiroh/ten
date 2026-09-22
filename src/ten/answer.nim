import std/rationals
import calculator

func evaluateAnswer*(input: string, digits: array[4, int]): Rational[int] =
  if input.len > 256:
    raise newException(ValueError, "Keep the expression within 256 characters.")
  var remaining: array[10, int]
  for digit in digits:
    if digit notin 0..9:
      raise newException(ValueError, "Puzzle digits must be between 0 and 9.")
    inc remaining[digit]
  for character in input:
    if character in {'0'..'9'}:
      let digit = ord(character) - ord('0')
      if remaining[digit] == 0:
        raise newException(ValueError, "Use each supplied digit exactly once.")
      dec remaining[digit]
  for count in remaining:
    if count != 0:
      raise newException(ValueError, "Use all four digits exactly once.")
  return evaluate(input, allowUnary = false)
