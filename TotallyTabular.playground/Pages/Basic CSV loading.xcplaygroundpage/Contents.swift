import TabularData

let plays = try DataFrame(contentsOfCSVFile: playsURL)

print(plays)

print(plays.summary())

print(plays.columns.map { $0.name })

let columns = ["play ID", "game ID", "game name", "date", "player 1 username", "player 1 win", "player 2 username", "player 2 win"]

//: [Next](@next)
