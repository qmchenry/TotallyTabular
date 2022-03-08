import Foundation
import TabularData

public let collectionURL = Bundle.main.url(forResource: "qeek-collection", withExtension: "csv")!
public let playsURL = Bundle.main.url(forResource: "qeek-plays-2022-03-06", withExtension: "csv")!

public let columns = ["play ID", "game ID", "game name", "date", "player 1 name", "player 1 win", "player 2 name", "player 2 win"]

public var options: CSVReadingOptions {
    var options = CSVReadingOptions()
    options.addDateParseStrategy(
        Date.ParseStrategy(
            format: "\(year: .defaultDigits)/\(month: .twoDigits)/\(day: .twoDigits)",
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone(abbreviation: "EST")!
        )
    )
    return options
}

public enum Winner {
    case jennifer
    case quinn
    case tie
}

public var processedPlays: DataFrame {

    var datedPlays = try! DataFrame(contentsOfCSVFile: playsURL, columns: columns, options: options)

    /// `game name` isn't very readable...

    datedPlays.transformColumn("game name") { data in
        String(data: data, encoding: .ascii)
    }

    /// Win or lose, let's be Bool with it

    func winner(name: String?, win: Int?) -> Winner? {
        guard let win = win, win == 1 else { return nil }
        switch name {
        case "Jennifer": return .jennifer
        case "Quinn": return .quinn
        default: return nil
        }
    }

    datedPlays.combineColumns(.init("player 1 name", String.self), .init("player 1 win", Int.self), into: "winner 1", transform: winner)
    datedPlays.combineColumns(.init("player 2 name", String.self), .init("player 2 win", Int.self), into: "winner 2", transform: winner)
    datedPlays.combineColumns(.init("winner 1", Winner.self), .init("winner 2", Winner.self), into: "winner") { (winner1, winner2) -> Winner? in
        switch (winner1, winner2) {
        case (.jennifer, .quinn), (.quinn, .jennifer): return .tie
        case (.jennifer, _), (_, .jennifer): return .jennifer
        case (.quinn, _), (_, .quinn): return .quinn
        default: return nil
        }
    }
    return DataFrame(datedPlays.filter(on: "winner", Winner.self) { $0 != nil })
}


public var joinedData: DataFrame {
    var collection = try! DataFrame(contentsOfCSVFile: collectionURL,
                                   columns: ["objectid", "rank", "yearpublished", "avgweight"],
                                   options: options)

    collection.transformColumn(.init("objectid", String.self)) { Int($0) }
    collection.transformColumn(.init("rank", String.self)) { Int($0) }
    collection.transformColumn(.init("yearpublished", String.self)) { Int($0) }
    collection.transformColumn(.init("avgweight", String.self)) { Float($0) }

    print(collection)
    collection.renameColumn("objectid", to: "game ID")

    return processedPlays.joined(collection, on: ("game ID")).sorted(on: "left.date", order: .descending)
}
