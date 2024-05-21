//
//  TagView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import SwiftUI
import SwiftData

struct TagDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var tag : Tag
    @State var bearbeitenOeffnen : Bool = false
    @State var ausgewaehlteAufgabe : Aufgabe? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header:Text("Grundinformationen")) {
                        HStack {
                            Text("Bezeichnung:")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(self.tag.bezeichnung)
                        }
                    }
                    if let aufgaben = tag.aufgaben {
                        if aufgaben.count > 0 {
                            Section(header:Text("Aufgaben")) {
                                ForEach(aufgaben, id:\.id) {
                                    aufgabe in
                                    AufgabeView(aufgabe: aufgabe)
                                    /*
                                    Button {
                                        self.ausgewaehlteAufgabe = aufgabe
                                    } label: {
                                        
                                    }*/
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(item: self.$ausgewaehlteAufgabe) {
                aufgabe in
                AufgabeDetailView(aufgabe: aufgabe)
            }
            .sheet(isPresented: self.$bearbeitenOeffnen) {
                TagAendernView(
                    tag: tag,
                    bezeichnung: tag.bezeichnung,
                    zugeordneteAufgaben: tag.aufgaben ?? [])
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    TabBarPrincipalView(principal: "Tags")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        bearbeitenOeffnen.toggle()
                    } label: {
                        Text("Bearbeiten")
                    }
                }
            }
            
        }
    }
}

#Preview {
    let schema = Schema([Aufgabe.self])
    let config = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: config)
    let tag = Tag(bezeichnung: "Filme")
    return TagDetailView(tag:tag)
        .modelContainer(container)
}
