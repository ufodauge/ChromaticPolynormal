import ../class/graph
import ../class/progressdata
import std/sequtils
import std/strformat


proc calcChromaticPolynormal*(
    graph: Graph,
    coefs: seq[int] = @[],
    depth: int = 0,
    pd: ProgressData = new ProgressData): seq[int] =
  ## returns a sequence of coefficients for the chromatic polynomial of the graph

  # init coef
  var coefficients: seq[int] = coefs
  if len(coefs) == 0:
    coefficients.insert(0.repeat(graph.getVerticiesCount() + 1))

  if graph.hasAnyEdge():
    var edge: array[2, string] = graph.getFirstEdge()

    var verticies: seq[string] = graph.getVerticies()
    var edges: seq[array[2, string]] = graph.getEdges()

    let sc = newGraph(verticies, edges)
    sc.shortCircuit(edge)

    let ct = newGraph(verticies, edges)
    ct.contract(edge)

    var res1: seq[int] = calcChromaticPolynormal(sc, coefficients, depth + 1, pd)
    var res2: seq[int] = calcChromaticPolynormal(ct, coefficients, depth + 1, pd)

    var res: seq[int] = @[]
    for i, t in zip(res1, res2):
      res.add(t[0] + t[1])

    pd.update(depth)
    pd.print()

    return res

  else:
    var verticiesCount: int = graph.getVerticiesCount()
    coefficients[verticiesCount] = coefficients[verticiesCount] + 1

    pd.updateNodesBelow(depth)
    pd.print()

    return coefficients


proc convertToExpression*(
    coefs: seq[int]): string =
  var expr: string = ""
  for i, c in coefs:
    if c == 0:
      continue
    if c == 1:
      if i == 1:
        expr = fmt(" + n") & expr
      else:
        expr = fmt(" + n^{i}") & expr
    else:
      if i == 1:
        expr = fmt(" + {c}n") & expr
      else:
        expr = fmt(" + {c}n^{i}") & expr

  return expr[3..(len(expr)-1)]


when isMainModule:
  echo ""
  echo ""

  let g = newGraph(
    @["A", "B", "C", "D", "E", "F"],
    @[["A", "B"],
      ["A", "C"],
      ["C", "A"],
      ["E", "F"],
      ["E", "D"],
      ["D", "F"],
      ["B", "D"],
      ["B", "E"]])


  var result: seq[int] = calcChromaticPolynormal(g)
  echo(convertToExpression(result))
