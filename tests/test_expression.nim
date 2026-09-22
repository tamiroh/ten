import std/[rationals, unittest]
import ../src/ten/[calculator, expression]

suite "Arithmetic expressions":
  test "literals are independent of puzzle rules":
    check literal(42).toString() == "42"
    check literal(-7).toString() == "-7"

  test "binary expressions preserve operand order":
    for operation in [(opAdd, "(1+3)"), (opSubtract, "(1-3)"),
        (opMultiply, "(1*3)"), (opDivide, "(1/3)")]:
      check combine(literal(1), literal(3), operation[0]).toString() == operation[1]

  test "nested expressions can share child expressions":
    let fraction = combine(literal(1), literal(3), opDivide)
    let sum = combine(fraction, fraction, opAdd)
    check sum.toString() == "((1/3)+(1/3))"
    check evaluate(sum.toString()) == 2 // 3
    check fraction.toString() == "(1/3)"

  test "construction represents expressions without evaluating them":
    let division = combine(literal(1), literal(0), opDivide)
    check division.toString() == "(1/0)"
    expect ValueError:
      discard evaluate(division.toString())

  test "nil expressions are rejected at compile time":
    static:
      doAssert not compiles(combine(nil, literal(1), opAdd))
      doAssert not compiles(combine(literal(1), nil, opAdd))
      doAssert not compiles(toString(nil))
      doAssert not compiles(block:
        let expression: Expression = nil
        discard expression)
