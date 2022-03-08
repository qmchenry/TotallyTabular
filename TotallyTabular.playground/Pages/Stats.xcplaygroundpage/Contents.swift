//: [Previous](@previous)
import TabularData

var mtcars = try DataFrame(contentsOfCSVFile: mtcarsURL)
print(mtcars)

print(mtcars.summary())

print(mtcars.grouped(by: "cyl").means("mpg", Double.self, order: .descending))

mtcars.transformColumn(ColumnID("hp", Int.self)) { Double($0) }
print(mtcars.grouped(by: "cyl").means("hp", Double.self, order: .descending))

//: [Next](@next)
