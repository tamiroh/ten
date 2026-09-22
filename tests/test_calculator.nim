import std/[rationals, strutils, unittest]
import ../src/ten/calculator

suite "Arithmetic evaluation":
  test "evaluation does not require a puzzle or four digits":
    check evaluate("7") == 7 // 1
    check evaluate("1 + 2") == 3 // 1
    check evaluate("1 + 2 + 3 + 4 + 5") == 15 // 1

  test "precedence, associativity and nested parentheses":
    check evaluate("1 + 2 + 3 * 4") == 15 // 1
    check evaluate("(1 + 2) * 4 - 3") == 9 // 1
    check evaluate("8 / 4 / 2 + 1") == 2 // 1
    check evaluate("8 - 4 - 2 - 1") == 1 // 1
    check evaluate("2 * (3 + (4 - 2))") == 10 // 1

  test "fractions and unary signs":
    check evaluate("1 / 3 + 1 / 6") == 1 // 2
    check evaluate("6 / (1 - 4 / 9)") == 54 // 5
    check evaluate(" -1 + 2 + 3 + 6 ") == 10 // 1
    check evaluate("-(2 + 3)") == -5 // 1

  test "invalid syntax is rejected without puzzle validation":
    for input in ["", "12+3-4", "1 2+3+4", "(1+2+3+4", "1+2+3+4)",
        "1+2+3+4=10", "1+2+3+4;quit", "1+2+3+4\0", "1+2+3+", "1**2+3+4",
        "1.2+3+4", repeat("(", 257)]:
      expect ValueError:
        discard evaluate(input)

  test "division by zero is recoverable":
    expect ValueError:
      discard evaluate("1 / (2 - 2)")
