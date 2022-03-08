//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport
import TabularData

struct ContentView: View {
    let idColumn = ColumnID("left.play ID", Int.self)
    let nameColumn = ColumnID("left.game name", String.self)
    let weightColumn = ColumnID("right.avgweight", Float.self)
    @State private var filtered = false
    @State private var table = joinedData

    var body: some View {
        ScrollView {
            ForEach(table.rows.map { ($0[idColumn], $0[nameColumn]) }, id: \.0) { (_, play) in
                Text(play ?? "NA")
            }
        }
        .frame(width: 400, height: 400)
        .onTapGesture {
            filtered.toggle()
            table = DataFrame(joinedData.filter(on: weightColumn, { filtered ? ($0 ?? 0) > 4 : true }))
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())


//: [Next](@next)
