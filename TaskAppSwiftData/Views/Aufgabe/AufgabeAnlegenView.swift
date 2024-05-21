//
//  Tas,E.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 13.05.24.
//

import SwiftUI
import SwiftData

struct AufgabeAnlegenView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var schliessen
    
    @State var errors : String = ""
    
    @State var bezeichnung : String = ""
    @State var bemerkung : String = ""
    
    @State var abgeschlossen : Bool = false
    
    @State var zeitpunktZumAbschliessen : Date = Date()
    
    @Query(sort:\Tag.bezeichnung) var tags : [Tag]
    @State var zugeordneteTags : [Tag] = []

    var body: some View {
        NavigationStack {
                HStack {
                    List {
                        ErrorSectionView(errors: self.errors)
                        
                        Section(header: Text("Grundinformationen")) {
                            TextFieldRemoveButton(textFieldTitle: "Bezeichnung", text: self.$bezeichnung)
                            TextFieldRemoveButton(
                                textFieldTitle: "Bemerkung",
                                text: self.$bemerkung)
                            .lineLimit(3...5)
                        }
                        Section(header: Text("Planung")) {
                            HStack {
                                Text("Geplant")
                                    .foregroundStyle(.gray)
                                Spacer()
                                DatePicker("",
                                           selection: $zeitpunktZumAbschliessen, displayedComponents: [.date, .hourAndMinute])
                                    .foregroundStyle(.gray)
                            }
                            HStack {
                                Text("Durchgeführt:")
                                    .foregroundStyle(.gray)
                                Spacer()
                                Toggle("", isOn: self.$abgeschlossen)
                            }
                        }
                        if tags.count > 0 {
                            Section(header:Text("Tags")) {
                                ForEach(tags, id:\.id) {
                                    tag in
                                    HStack {
                                        Text(tag.bezeichnung)
                                        Spacer()
                                        Button {
                                            self.zugeordneteTags.removeOrAddElement(element: tag)
                                        } label: {
                                            let tagZugeordnet = self.zugeordneteTags.containsElement(element: tag)
                                            Image(systemName: tagZugeordnet ? "checkmark.square.fill" : "square")
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            self.schliessen.callAsFunction()
                        } label: {
                            Text("Abbrechen")
                                .foregroundStyle(.blue)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Neue Aufgabe")
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            self.errors = self.speichern()
                            if errors.isEmpty {
                                self.schliessen.callAsFunction()
                            }
                        } label: {
                            Text("Sichern")
                                .foregroundStyle(.blue)
                        }
                    }
            }
        }
    }
    private func speichern() -> String {
        withAnimation {
            let aufgabe = Aufgabe(
                bezeichnung: self.bezeichnung,
                bemerkung: self.bemerkung,
                zeitpunktZumAbschliessen: self.zeitpunktZumAbschliessen.timeIntervalSince1970)
            
            if(self.abgeschlossen) {
                aufgabe.abschliessen()
            }
            let errors = aufgabe.validate()
            if(errors.isEmpty) {
                NotificationManager.instance.scheduledNotificationFuerAufgabe(aufgabe: aufgabe)
                modelContext.insert(aufgabe)
            }
            return errors
        }
    }
}

#Preview {
    let schema = Schema([Aufgabe.self])
    let config = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: config)
    return AufgabeAnlegenView()
            .modelContainer(container)
}
