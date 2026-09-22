import std/[rationals, unittest]
import ../src/ten/[calculator, expression]

suite "Arithmetic expressions":
  test "literals are independent of puzzle rules":
    let nodes = @[literal(42), literal(-7)]
    check nodes[0].value == 42 // 1
    check nodes.toString(0) == "42"
    check nodes.toString(1) == "-7"

  test "binary nodes retain exact values and operand order":
    var nodes = @[literal(1), literal(3)]
    for operator in ['+', '-', '*', '/']:
      nodes.add(nodes.combine(0, 1, operator))
      check nodes[^1].value == evaluate(nodes.toString(nodes.high))
    check nodes[^1].value == 1 // 3
    check nodes.toString(nodes.high) == "(1/3)"

  test "nested expressions can share child nodes":
    var nodes = @[literal(1), literal(3)]
    nodes.add(nodes.combine(0, 1, '/'))
    nodes.add(nodes.combine(2, 2, '+'))
    check nodes[3].value == 2 // 3
    check nodes.toString(3) == "((1/3)+(1/3))"
    check nodes[2].value == 1 // 3

  test "invalid operations are rejected":
    let nodes = @[literal(1), literal(0)]
    expect ValueError:
      discard nodes.combine(0, 1, '/')
    expect ValueError:
      discard nodes.combine(0, 1, '^')
