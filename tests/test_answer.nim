import std/[rationals, unittest]
import ../src/ten/answer

suite "Answer evaluation":
  test "valid answers are evaluated":
    check evaluateAnswer("1 + 2 + 3 + 4", [1, 2, 3, 4]) == 10 // 1
    check evaluateAnswer("3 * 3 + 1 + 0", [3, 3, 1, 0]) == 10 // 1
    check evaluateAnswer("6 / (1 - 4 / 9)", [6, 1, 4, 9]) == 54 // 5

  test "every supplied digit must be used exactly once":
    for input in ["1+2+3", "1+2+3+3", "1+2+3+5", "1+2+3+4+4"]:
      expect ValueError:
        discard evaluateAnswer(input, [1, 2, 3, 4])

  test "invalid puzzle digits are rejected":
    for digits in [[-1, 2, 3, 4], [10, 2, 3, 4]]:
      expect ValueError:
        discard evaluateAnswer("1+2+3+4", digits)

  test "using the right digits does not bypass syntax checks":
    for input in ["12+3-4", "1 2+3+4", "(1+2+3+4", "1+2+3+4)",
        "1+2+3+4;quit", "1+2+3+4\0", "1.2+3+4"]:
      expect ValueError:
        discard evaluateAnswer(input, [1, 2, 3, 4])

  test "division by zero is recoverable":
    expect ValueError:
      discard evaluateAnswer("1 / (2 - 2) + 3", [1, 2, 2, 3])

  test "unary signs are not accepted in puzzle answers":
    for input in ["-1+2+3+6", "+1+2+3+6", "1--2+3+6",
        "1+(-2)+3+6"]:
      expect ValueError:
        discard evaluateAnswer(input, [1, 2, 3, 6])
