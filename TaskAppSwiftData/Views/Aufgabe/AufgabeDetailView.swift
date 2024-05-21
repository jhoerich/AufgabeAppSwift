//
//  AufgabeDetailView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 16.05.24.
//

import SwiftUI
import SwiftData

struct AufgabeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var aufgabe : Aufgabe
    
    @State var bearbeitenOeffnen : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Grundinformationen")) {
                        HStack {
                            Text("Bezeichnung:")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(self.aufgabe.bezeichnung)
                        }
                        if !self.aufgabe.bemerkung.isEmpty {
                            HStack {
                                Text("Bemerkung:")
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text(self.aufgabe.bemerkung)
                                    .lineLimit(1...5)
                            }
                        }
                    }
                    Section(header: Text("Planung")) {
                        HStack {
                            Text("Geplant:")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(self.aufgabe.zeitpunktZumAbschliessen.asConvertedDateTimeString())
                        }
                        if let abgeschlossen = self.aufgabe.zeitpunktAbgeschlossen {
                            HStack {
                                Text("Durchgeführt:")
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text(abgeschlossen.asConvertedDateTimeString())
                            }
                        }
                    }
                    if let tags = aufgabe.tags {
                        if !tags.isEmpty {
                            Section(header: Text("Tags")) {
                                let sortedTags = tags
                                    .map { $0.bezeichnung }
                                    .sorted(by: { $0 < $1 })
                                Text(sortedTags.joined(separator: ", "))
                            }
                        }
                    }
                    if(!aufgabe.abgeschlossen) {
                        Button {
                            withAnimation {
                                aufgabe.abschliessen()
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Abschliessen")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                    }else {
                        HStack {
                            Spacer()
                            Text("Aufgabe ist bereits abgeschlossen!")
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }
                }.listStyle(.insetGrouped)
                
                
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Aufgabe")
                        .foregroundStyle(.blue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        bearbeitenOeffnen.toggle()
                    } label: {
                        Text("Bearbeiten")
                    }.disabled(aufgabe.abgeschlossen)
                }
            }
        }.sheet(isPresented: self.$bearbeitenOeffnen) {
            let zeitpunktZumAbschliessen = Date(timeIntervalSince1970: aufgabe.zeitpunktZumAbschliessen)
            AufgabeAendernView(
                aufgabe: aufgabe,
                bezeichnung: aufgabe.bezeichnung,
                bemerkung: aufgabe.bemerkung,
                zeitpunktZumAbschliessen: zeitpunktZumAbschliessen,
                zugeordneteTags: aufgabe.tags ?? [])
        }
    }
}

#Preview {
    let schema = Schema([Aufgabe.self])
    let config = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: config)
    
    let aufgabe = Aufgabe(bezeichnung: "Test123", bemerkung: "Hello Welt", zeitpunktZumAbschliessen: Date().timeIntervalSince1970, tags: [])
    
    return AufgabeDetailView(aufgabe: aufgabe)
        .modelContainer(container)
}
