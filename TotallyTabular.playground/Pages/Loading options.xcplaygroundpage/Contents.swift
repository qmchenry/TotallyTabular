import Foundation
import TabularData

/// Limit columns read
/// `columns = ["play ID", "game ID", "game name", "date", "player 1 username", "player 1 win", "player 2 username", "player 2 win"]`

let plays = try DataFrame(contentsOfCSVFile: playsURL, columns: columns, rows: 0..<20)
print(plays)

/// Let's make that date a Date

var options = CSVReadingOptions()
options.addDateParseStrategy(
    Date.ParseStrategy(
        format: "\(year: .defaultDigits)/\(month: .twoDigits)/\(day: .twoDigits)",
        locale: Locale(identifier: "en_US"),
        timeZone: TimeZone(abbreviation: "EST")!
    )
)

var datedPlays = try DataFrame(contentsOfCSVFile: playsURL, columns: columns, rows: 0..<100, options: options)
print(datedPlays)

/// `game name` isn't very readable...

datedPlays.transformColumn("game name") { data in
    String(data: data, encoding: .ascii)
}
print(datedPlays)

print(datedPlays.summary(of: "game name"))

/// Win or lose, let's be Bool with it

enum WinnerName {
    case jennifer
    case quinn
    case tie
}

func winner(name: String?, win: Int?) -> WinnerName? {
    guard let win = win, win == 1 else { return nil }
    switch name {
    case "Jennifer": return .jennifer
    case "Quinn": return .quinn
    default: return nil
    }
}

datedPlays.combineColumns(.init("player 1 name", String.self), .init("player 1 win", Int.self), into: "winner 1", transform: winner)
print(datedPlays)
datedPlays.combineColumns(.init("player 2 name", String.self), .init("player 2 win", Int.self), into: "winner 2", transform: winner)
print(datedPlays)

datedPlays.combineColumns(.init("winner 1", WinnerName.self), .init("winner 2", WinnerName.self), into: "winner") { (winner1, winner2) -> WinnerName? in
    switch (winner1, winner2) {
    case (.jennifer, .quinn), (.quinn, .jennifer): return .tie
    case (.jennifer, _), (_, .jennifer): return .jennifer
    case (.quinn, _), (_, .quinn): return .quinn
    default: return nil
    }
}

print(datedPlays)

/// -> `processedPlays`

print(processedPlays)
