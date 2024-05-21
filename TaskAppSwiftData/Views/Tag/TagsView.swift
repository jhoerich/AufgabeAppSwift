//
//  TagsView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import SwiftUI
import SwiftData

struct TagsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort:\Tag.bezeichnung) var tags : [Tag]
    
    @State var oeffneTagErstellen : Bool = false
    @State var ausgewaehlterTag : Tag? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(self.tags, id:\.id) {
                    tag in
                    Button {
                        self.ausgewaehlterTag = tag
                    } label: {
                        TagView(tag: tag)
                    }
                } .onDelete(perform: { offset in
                    offset.forEach {
                        index in
                        let tag = tags[index]
                        modelContext.delete(tag)
                    }
                })
            }
            .navigationDestination(item: $ausgewaehlterTag) {
                tag in
                TagDetailView(tag: tag)
            }
            .sheet(isPresented: $oeffneTagErstellen, content: {
                TagAnlegenView()
            })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TabBarPrincipalView(principal: "Tags")
                }
                ToolbarItem {
                    Button {
                        oeffneTagErstellen.toggle()
                    } label: {
                        Label("Tag erstellen", systemImage: "plus")
                    }
                }
            }
        }
        .tabItem {
            TabItemTextView(imageName: "tag", text: "Tags")
        }
    }
}

#Preview {
    let schema = Schema([Aufgabe.self])
    let configuration = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: configuration)
    
    return TagsView()
        .modelContainer(container)
}
