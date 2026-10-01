# ten

A CLI 10 puzzle game.

## Install

Requires Nim 2.2.12 or later.

```sh
nimble install https://github.com/tamiroh/ten
```

Make sure `~/.nimble/bin` is in your `PATH`, then run `ten`.

## How to play

```sh
nimble run
```

Use all four digits exactly once with `+ - * /` and parentheses to make 10.
Do not join digits into larger numbers.
Unary signs are not allowed in puzzle answers.
Every puzzle has a solution.

For example, with `1 2 3 4`, enter `1+2+3+4`.

- `next`: Skip to the next puzzle.
- `answers` / `a`: Show all solutions for the current puzzle.
- `quit`: Exit.
- Up / Down: Browse input history from the current session.
