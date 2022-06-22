import ../class/graph
import ../class/progressdata
import std/sequtils
import std/strformat


proc combination(ni: int, ri: int): int =
  var n: int = ni
  var r: int = ri

  var v = newSeqWith(n+1, newSeq[int](n+1))

  for i in 0..n:
    v[i][0] = 1
    v[i][i] = 1

  for k in 1..n:
    for j in 1..<k:
      v[k][j] = v[k-1][j-1] + v[k-1][j]

  return v[n][r]


proc calcChromaticPolynormal*(
    graph: Graph,
    pd: ProgressData = newProgressData(),
    coefs: seq[int] = @[],
    depth: int = 0): seq[int] =
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

    var res1: seq[int] = calcChromaticPolynormal(sc, pd, coefficients,
            depth + 1)
    var res2: seq[int] = calcChromaticPolynormal(ct, pd, coefficients,
            depth + 1)

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


proc calcChromaticPolynormal2*(
    graph: Graph,
    pd: ProgressData = newProgressData(),
    coefs: seq[int] = @[],
    depth: int = 0): seq[int] =
  ## returns a sequence of coefficients for the chromatic polynomial of the graph

  # init coef
  # @[coef of ^0, coef of ^1, coef of ^2, ...]
  var coefficients: seq[int] = coefs
  if len(coefs) == 0:
    coefficients.insert(0.repeat(graph.getVerticiesCount() + 1))


  if not graph.hasAnyEdge():
    # there is no edges

    var verticiesCount: int = graph.getVerticiesCount()
    coefficients[verticiesCount] = coefficients[verticiesCount] + 1

    pd.updateNodesBelow(depth)
    pd.print()

    return coefficients


  elif graph.isSeparated():
    let (verticies1, edges1, verticies2, edges2) = graph.getSeparated()

    let g1 = newGraph(verticies1, edges1)
    let g2 = newGraph(verticies2, edges2)

    var res1: seq[int] = calcChromaticPolynormal(g1, pd, coefficients, depth + 1)
    var res2: seq[int] = calcChromaticPolynormal(g2, pd, coefficients, depth + 1)

    var res: seq[int] = @[]
    for i, t in zip(res1, res2):
      res.add(t[0] + t[1])

    pd.update(depth)
    pd.print()

    return res


  elif graph.isCircuit():
    var verticiesCount: int = graph.getVerticiesCount()
    # (-1)^n (c - 1) + (c - 1)^n
    # -x1--- -x2----   -x3------
    let x1 =
      if verticiesCount mod 2 == 0: 1
      else: -1

    # x2
    coefficients[0] = -1 * x1
    coefficients[1] = 1 * x1

    # x3
    for i in 0..(verticiesCount):
      let comb = combination(verticiesCount, i)
      let x1 =
        if i mod 2 == 0: 1
        else: -1
      coefficients[i] += comb * x1

    pd.updateNodesBelow(depth)
    pd.print()

    return coefficients


  elif graph.isTree():
    # c(c - 1)^(n - 1)
    var verticiesCount: int = graph.getVerticiesCount()

    for i in 0..(verticiesCount):
      let comb = combination(verticiesCount, i)
      let x1 =
        if i mod 2 == 0: 1
        else: -1
      coefficients[i+1] += comb * x1

    pd.updateNodesBelow(depth)
    pd.print()

    return coefficients


  elif graph.isComlete():
    # c(c - 1)(c - 2)...(c - (n - 1))
    echo ""


  else:
    var edge: array[2, string] = graph.getFirstEdge()

    var verticies: seq[string] = graph.getVerticies()
    var edges: seq[array[2, string]] = graph.getEdges()

    let sc = newGraph(verticies, edges)
    sc.shortCircuit(edge)

    let ct = newGraph(verticies, edges)
    ct.contract(edge)

    var res1: seq[int] = calcChromaticPolynormal(sc, pd, coefficients, depth + 1)
    var res2: seq[int] = calcChromaticPolynormal(ct, pd, coefficients, depth + 1)

    var res: seq[int] = @[]
    for i, t in zip(res1, res2):
      res.add(t[0] + t[1])

    pd.update(depth)
    pd.print()

    return res


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
  echo combination(2, 1)
  echo combination(3, 1)
  echo combination(4, 1)
  echo combination(4, 2)
  echo combination(4, 3)
  echo combination(5, 3)
  echo combination(5, 4)
  # let g = newGraph(
  #     @["A", "B", "C", "D", "E", "F"],
  #     @[["A", "B"],
  #     ["A", "C"],
  #     ["C", "A"],
  #     ["E", "F"],
  #     ["E", "D"],
  #     ["D", "F"],
  #     ["B", "D"],
  #     ["B", "E"]])

  # let pd = newProgressData(updateFreq = 1000)
  # var result: seq[int] = calcChromaticPolynormal(g, pd)
  # echo(convertToExpression(result))
