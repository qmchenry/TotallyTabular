//: [Previous](@previous)

import TabularData

let plays = try DataFrame(contentsOfCSVFile: playsURL)

print(plays)

print(plays.summary())

let columns = ["play ID", "game ID", "game name", "date", "player 1 username", "player 1 win", "player 2 username", "player 2 win"]

//: [Next](@next)
