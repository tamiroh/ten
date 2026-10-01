import std/[hashes, rationals, sets, unittest]
import ../src/ten/[calculator, expression]

suite "Arithmetic expressions":
  test "equality and hashing compare structure rather than identity or value":
    let first = combine(literal(1), literal(2), opAdd)
    let second = combine(literal(1), literal(2), opAdd)
    check first == second
    check hash(first) == hash(second)
    check first != combine(literal(2), literal(1), opAdd)
    check first != combine(literal(1), literal(2), opMultiply)
    check first != literal(3)
    check @[first, second].toHashSet.len == 1

  test "literals are independent of puzzle rules":
    check $literal(42) == "42"
    check $literal(-7) == "-7"

  test "binary expressions preserve operand order":
    for operation in [(opAdd, "(1+3)"), (opSubtract, "(1-3)"),
        (opMultiply, "(1*3)"), (opDivide, "(1/3)")]:
      check $combine(literal(1), literal(3), operation[0]) == operation[1]

  test "nested expressions can share child expressions":
    let fraction = combine(literal(1), literal(3), opDivide)
    let sum = combine(fraction, fraction, opAdd)
    check $sum == "((1/3)+(1/3))"
    check evaluate($sum) == 2 // 3
    check $fraction == "(1/3)"

  test "construction represents expressions without evaluating them":
    let division = combine(literal(1), literal(0), opDivide)
    check $division == "(1/0)"
    expect ValueError:
      discard evaluate($division)

  test "nil expressions are rejected at compile time":
    static:
      doAssert not compiles(combine(nil, literal(1), opAdd))
      doAssert not compiles(combine(literal(1), nil, opAdd))
      doAssert not compiles(expression.`$`(nil))
      doAssert not compiles(block:
        let expression: Expression = nil
        discard expression)
