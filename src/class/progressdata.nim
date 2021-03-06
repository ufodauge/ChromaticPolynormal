import math
import std/terminal
import std/strformat
import std/strutils


type
  ProgressData* = ref object
    # private
    depthProgress: seq[int]
    depthProgressMax: seq[int]
    lines: int
    updateFreq: int
    waits: int


proc newDepth*(self: ProgressData): void =
  self.depthProgress.add(0)
  self.depthProgressMax.add(2^(len(self.depthProgress)-1))
  # echo ""


proc update*(self: ProgressData, depth: int): void =
  while len(self.depthProgress) <= depth:
    self.newDepth()
  self.depthProgress[depth] += 1


proc updateNodesBelow*(self: ProgressData, depth: int): void =
  self.update(depth)
  for dpt in countup(depth+1, len(self.depthProgress)-1):
    self.depthProgress[dpt] += 2^(dpt - depth)


proc print*(self: ProgressData): void =
  ## print all progress data
  self.waits += 1
  if self.waits >= self.updateFreq:
    self.waits = 0
    if self.lines > 0:
      stdout.cursorUp(self.lines)
      self.lines = 0
    for i, dp in self.depthProgress:
      var percent: float = self.depthProgress[i] / self.depthProgressMax[i] * 100
      var progressInt: int = int(percent / 2)
      stdout.eraseLine()
      echo(fmt("{i:>3} |") &
          ("#").repeat(progressInt) &
          (" ").repeat(50 - progressInt) &
          fmt("| {percent:6f} [%]"))
      self.lines += 1


proc newProgressData*(updateFreq: int = 1000): ProgressData =
  let pd = new ProgressData
  pd.lines = 0
  pd.waits = 0
  pd.updateFreq = updateFreq

  return pd


when isMainModule:
  echo "\n"

  let pd = new ProgressData
  pd.update(0)
  pd.print()

  pd.update(1)
  pd.print()

  pd.update(5)
  pd.update(5)
  pd.print()

  pd.update(10)
  pd.print()

  pd.updateNodesBelow(3)
  pd.print()
  echo ""
