//
//  TagView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import SwiftUI
import SwiftData

struct TagView: View {
    @Environment(\.modelContext) private var modelContext
    @State var tag : Tag
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("\(tag.bezeichnung)")
                    .font(.system(size: 18))
                Spacer()
                HStack {
                    Text("Aufgaben:")
                    if let aufgaben = tag.aufgaben {
                        Text("\(aufgaben.count)")
                    }else {
                        Text("0")
                    }
                }
                .font(.system(size: 12))
                .foregroundStyle(.black)
            }
        }.padding()
    }
}

#Preview {
    let schema = Schema([Aufgabe.self])
    let config = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: config)
    let tag = Tag(bezeichnung: "Filme")
    return TagView(tag:tag)
        .modelContainer(container)
}
