import std/algorithm
import std/sequtils


type
  NoEdgeFoundInGraphError* = object of OSError

type
  Graph* = ref object
    # private
    verticies: seq[string]
    edges: seq[array[2, string]]


proc isSameEdge(e1: array[2, string], e2: array[2, string]): bool =
  ## ret two edges are same
  return (e1 == e2 or e1 == e2.reversed())


proc toString*(self: Graph): string =
  ## toString
  var s: string = "Graph( verticies: ["
  for i, v in self.verticies:
    if i > 0:
      s &= ", "
    s &= v
  s &= "], edges: ["
  for i, e in self.edges:
    if i > 0:
      s &= ", "
    s &= "(" & e[0] & ", " & e[1] & ")"
  s &= "])"

  return s


proc removeEdge*(self: Graph, edge: array[2, string]): void =
  ## removeEdge
  for i, e in self.edges:
    if isSameEdge(e, edge):
      self.edges.del(i)
      return

  raise newException(NoEdgeFoundInGraphError, "Edge not found")


proc removeDupeEdges*(self: Graph): void =
  ## removeDupeEdges
  ## remove edges that are duplicates of each other
  ## (e.g. (a, b) and (b, a))
  for i in countup(0, len(self.edges) - 1):
    if len(self.edges) <= i:
      break
    var e1: array[2, string] = self.edges[i]
    for j in countdown(len(self.edges) - 1, i + 1):
      var e2: array[2, string] = self.edges[j]
      if isSameEdge(e1, e2):
        self.edges.del(j)


proc shortCircuit*(self: Graph, edge: array[2, string]): void =
  ## shortCircuit
  self.removeEdge(edge)


proc contract*(self: Graph, edge: array[2, string]): void =
  ## contract
  ## merge v2 into v1
  let v1 = edge[0]
  let v2 = edge[1]

  # remove edge and v2 from graph
  self.removeEdge(edge)
  self.verticies = self.verticies.filter(proc(v: string): bool = v != v2)

  # replace all edges that point to v2 with v1
  for i, e in self.edges:
    if e[1] == v2:
      self.edges[i][1] = v1
    if e[0] == v2:
      self.edges[i][0] = v1
    self.edges[i].sort(system.cmp[string])

  # remove duplicate edges
  self.removeDupeEdges()


proc getVerticies*(self: Graph): seq[string] =
  return self.verticies


proc getEdges*(self: Graph): seq[array[2, string]] =
  return self.edges


proc getVerticiesCount*(self: Graph): int =
  ## getVerticiesCount
  return len(self.verticies)


proc hasAnyEdge*(self: Graph): bool =
  ## hasEdge
  return len(self.edges) > 0


proc getFirstEdge*(self: Graph): array[2, string] =
  ## getRandomEdge
  return self.edges[0]


proc newGraph*(verticies: seq[string], edges: seq[array[2, string]]): Graph =
  ## constructor
  var graph = new Graph
  graph.verticies = deepcopy(verticies)
  graph.edges = deepcopy(edges)

  # remove duplicate edges
  graph.removeDupeEdges()

  # remove self-loop
  for i in countup(0, len(graph.edges)):
    if len(graph.edges) <= i:
      break
    var e: array[2, string] = graph.edges[i]
    if e[0] == e[1]:
      graph.edges.del(i)

  return graph


when isMainModule:
  echo ""
  echo ""
  let graph = newGraph(
    @["A", "B", "C", "D", "E", "F"],
    @[["A", "B"],
      ["A", "C"],
      ["C", "A"],
      ["A", "D"],
      ["A", "D"],
      ["B", "E"],
      ["C", "E"],
      ["D", "E"],
      ["D", "F"],
      ["F", "F"],
      ["E", "F"]])
  # -> ["A", "B"],
  #    ["A", "C"],
  #    ["A", "D"],
  #    ["B", "E"],
  #    ["C", "E"],
  #    ["D", "E"],
  #    ["D", "F"],
  #    ["E", "F"]

  echo(graph.toString())

  graph.shortCircuit(["A", "B"])
  echo(graph.toString())

  graph.contract(["D", "E"])
  echo(graph.toString())

  echo(graph.getVerticiesCount())
  echo(graph.hasAnyEdge())
  echo(graph.getFirstEdge())


