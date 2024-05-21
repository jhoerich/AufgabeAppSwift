//
//  AufgabeAendernView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 17.05.24.
//

import SwiftUI
import SwiftData

struct AufgabeAendernView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var aufgabe : Aufgabe
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
                                           selection: self.$zeitpunktZumAbschliessen, displayedComponents: [.date, .hourAndMinute])
                                    .foregroundStyle(.gray)
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
                            self.dismiss()
                        } label: {
                            Text("Abbrechen")
                                .foregroundStyle(.blue)
                        }
                    }
                ToolbarItem(placement: .principal) {
                    Text("Aufgabe ändern")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.errors = self.speichern()
                        if errors.isEmpty {
                            self.dismiss()
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
            aufgabe.bezeichnung = self.bezeichnung
            aufgabe.bemerkung = self.bemerkung
            aufgabe.zeitpunktZumAbschliessen =
            self.zeitpunktZumAbschliessen.timeIntervalSince1970
            aufgabe.tags = self.zugeordneteTags
            
            if(self.abgeschlossen) {
                aufgabe.abschliessen()
            }
            let errors = aufgabe.validate()
            if(errors.isEmpty) {
            }
            return errors
        }
    }
}

#Preview {
    let schema = Schema([Aufgabe.self])
    let config = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: config)
    let aufgabe = Aufgabe(bezeichnung: "Test123", bemerkung: "Test12", zeitpunktZumAbschliessen: Date().timeIntervalSince1970)
    
    return AufgabeAendernView(aufgabe: aufgabe, bezeichnung: aufgabe.bezeichnung,
                              bemerkung: aufgabe.bemerkung, zeitpunktZumAbschliessen: Date(timeIntervalSince1970: aufgabe.zeitpunktZumAbschliessen))
        .modelContainer(container)
}
