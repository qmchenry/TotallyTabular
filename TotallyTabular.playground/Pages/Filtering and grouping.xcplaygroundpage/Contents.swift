//: [Previous](@previous)
import Foundation
import TabularData

/// `head`
print(processedPlays.prefix(5))

/// `tail`
print(processedPlays.suffix(5))

print(processedPlays.summary(of: "game name"))

/// `filter`
print(processedPlays.filter(on: "winner", Winner.self, { $0 == .tie }))

print(processedPlays.filter(on: "game name", String.self, { ($0 ?? "").hasPrefix("Q") }))

let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: .now)!
print(processedPlays.filter(on: "date", Date.self, { ($0 ?? .distantPast) > lastMonth }).sorted(on: "date", order: .descending))

/// `group_by`
print(processedPlays.grouped(by: "game name").counts(order: .descending))

print(processedPlays.grouped(by: "date", timeUnit: .weekday).counts(order: .descending))

print(processedPlays.grouped(by: "date", timeUnit: .year).counts(order: .descending))

/// column `names`
print(processedPlays.columns.map { $0.name })

//: [Next](@next)
