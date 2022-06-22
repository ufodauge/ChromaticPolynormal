import class/graph
import class/progressdata
import module/calculator


when isMainModule:
  let g = newGraph(
    @["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12",
      "v13", "v14", "v15", "v16", "v17", "v18", "v19", "v20"],
    @[
      ["v1", "v2"],
      ["v2", "v3"],
      ["v3", "v4"],
      ["v4", "v5"],
      ["v5", "v1"],
      ["v1", "v6"],
      ["v2", "v7"],
      ["v3", "v8"],
      ["v4", "v9"],
      ["v5", "v10"],
      ["v6", "v11"],
      ["v7", "v12"],
      ["v8", "v13"],
      ["v9", "v14"],
      ["v10", "v15"],
      ["v6", "v15"],
      ["v7", "v14"],
      ["v8", "v13"],
      ["v9", "v12"],
      ["v10", "v11"],
      ["v11", "v16"],
      ["v12", "v17"],
      ["v13", "v18"],
      ["v14", "v19"],
      ["v15", "v20"],
      ["v16", "v17"],
      ["v17", "v18"],
      ["v18", "v19"],
      ["v19", "v20"],
      ["v20", "v16"]
    ])

  let pd = newProgressData(updateFreq = 100000)
  var result: seq[int] = calcChromaticPolynormal(g, pd)
  echo(convertToExpression(result))

