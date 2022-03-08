//: [Previous](@previous)
import TabularData

var options = CSVReadingOptions()
options.usesEscaping = true
var collection = try DataFrame(contentsOfCSVFile: collectionURL,
                               columns: ["objectid", "rank", "yearpublished", "avgweight"],  // 58 original columns -> 4
                               options: options)
print(collection)

collection.transformColumn(ColumnID("objectid", String.self)) { Int($0) }
collection.transformColumn(ColumnID("rank", String.self)) { Int($0) }
collection.transformColumn(ColumnID("yearpublished", String.self)) { Int($0) }
collection.transformColumn(ColumnID("avgweight", String.self)) { Float($0) }

print(collection)

collection.renameColumn("objectid", to: "game ID")
let joined = processedPlays.joined(collection, on: ("game ID"))

print(joined.columns.map { $0.name })

print(joined.sorted(on: "right.yearpublished", order: .descending))

//: [Next](@next)
