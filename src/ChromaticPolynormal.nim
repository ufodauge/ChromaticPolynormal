import class/graph
import class/progressdata
import module/calculator


when isMainModule:
  let g = newGraph(
    @["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12",
      "v13", "v14", "v15", "v16", "v17", "v18", "v19", "v20"],
    @[
      # bridge
    ["v1", "v6"],
    ["v2", "v8"],
    ["v3", "v10"],
    ["v4", "v12"],
    ["v5", "v14"],

    ["v7", "v16"],
    ["v9", "v17"],
    ["v11", "v18"],
    ["v13", "v19"],
    ["v15", "v20"],

      # circuits
    ["v1", "v2"],
    ["v2", "v3"],
    ["v3", "v4"],
    ["v4", "v5"],
    ["v5", "v1"],

    ["v6", "v7"],
    ["v7", "v8"],
    ["v8", "v9"],
    ["v9", "v10"],
    ["v10", "v11"],
    ["v11", "v12"],
    ["v12", "v13"],
    ["v13", "v14"],
    ["v14", "v15"],
    ["v15", "v6"],

    ["v16", "v17"],
    ["v17", "v18"],
    ["v18", "v19"],
    ["v19", "v20"],
    ["v20", "v16"],
  ])

  let pd = newProgressData(updateFreq = 100000)
  var result: seq[int] = calcChromaticPolynormal(g, pd)
  echo(convertToExpression(result))

