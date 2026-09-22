import std/[rationals, strutils, unittest]
import ../src/ten/answer

suite "Answer evaluation":
  test "operator precedence and parentheses":
    check evaluateAnswer("1 + 2 + 3 * 4", [1, 2, 3, 4]) == 15 // 1
    check evaluateAnswer("(1 + 2) * 4 - 3", [1, 2, 3, 4]) == 9 // 1
    check evaluateAnswer("8 / 4 / 2 + 1", [8, 4, 2, 1]) == 2 // 1
    check evaluateAnswer("8 - 4 - 2 - 1", [8, 4, 2, 1]) == 1 // 1

  test "exact fractions, repeated digits and zero":
    check evaluateAnswer("(6 / 7 + 8) * 7", [6, 7, 8, 7]) == 62 // 1
    check evaluateAnswer("6 / (1 - 4 / 9)", [6, 1, 4, 9]) == 54 // 5
    check evaluateAnswer("3 * 3 + 1 + 0", [3, 3, 1, 0]) == 10 // 1
    check evaluateAnswer(" -1 + 2 + 3 + 6 ", [1, 2, 3, 6]) == 10 // 1

  test "every supplied digit must be used exactly once":
    for input in ["1+2+3", "1+2+3+3", "1+2+3+5", "1+2+3+4+4"]:
      expect ValueError:
        discard evaluateAnswer(input, [1, 2, 3, 4])

  test "invalid syntax is rejected":
    for input in ["", "12+3-4", "1 2+3+4", "(1+2+3+4", "1+2+3+4)",
        "1+2+3+4=10", "1+2+3+4;quit", "1+2+3+4\0", "1+2+3+", "1**2+3+4",
        "1.2+3+4", repeat("(", 257)]:
      expect ValueError:
        discard evaluateAnswer(input, [1, 2, 3, 4])

  test "division by zero is recoverable":
    expect ValueError:
      discard evaluateAnswer("1 / (2 - 2) + 3", [1, 2, 2, 3])
