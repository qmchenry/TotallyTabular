//: [Previous](@previous)

import TabularData

let mtcars = try DataFrame(contentsOfCSVFile: mtcarsURL)
print(mtcars)

print(mtcars.summary())

print(mtcars.grouped(by: "cyl").means("mpg", Double.self, order: .descending))

//: [Next](@next)
