import std/[linenoise, strutils, terminal]

proc readPrompt*(line: var string): bool =
  if not (stdin.isatty and stdout.isatty):
    stdout.write("> ")
    stdout.flushFile()
    return stdin.readLine(line)

  let buffer = linenoise.readLine("> ")
  if buffer == nil:
    return false
  defer: linenoise.free(buffer)
  line = $buffer
  if line.strip.len > 0:
    discard linenoise.historyAdd(buffer)
  return true
