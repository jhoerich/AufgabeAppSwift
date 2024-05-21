//
//  TagView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import SwiftUI
import SwiftData

struct TagAnlegenView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var bezeichnung : String = ""
    
    @Query(sort:\Aufgabe.bezeichnung) var aufgaben : [Aufgabe]
    
    @State var zugeordneteAufgaben : [Aufgabe] = []
    @State var errors : String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ErrorSectionView(errors: self.errors)
                    
                    Section(header:Text("Grundinformationen")) {
                        TextFieldRemoveButton(
                            textFieldTitle: "Bezeichnung",
                            text: self.$bezeichnung)
                    }
                    if aufgaben.count > 0 {
                        Section(header:Text("Aufgaben")) {
                            ForEach(aufgaben, id:\.id) {
                                aufgabe in
                                HStack {
                                    Text(aufgabe.bezeichnung)
                                    Spacer()
                                    Button {
                                        self.zugeordneteAufgaben.removeOrAddElement(element: aufgabe)
                                    } label: {
                                        let aufgabeZugeordnet = self.zugeordneteAufgaben.containsElement(element: aufgabe)
                                        Image(systemName: aufgabeZugeordnet ? "checkmark.square.fill" : "square")
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text("Abbrechen")
                            .foregroundStyle(.blue)
                    }
                }
                ToolbarItem(placement: .principal){
                    TabBarPrincipalView(principal: "Tags")
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
    
    private func istAufgabeZugeordnet(aufgabe: Aufgabe) -> Bool {
        return self.zugeordneteAufgaben.contains(where: { $0.id == aufgabe.id})
    }
    
    private func speichern() -> String {
        withAnimation {
            let tag = Tag(bezeichnung: self.bezeichnung)
            tag.aufgabenHinzufuegen(aufgaben: self.zugeordneteAufgaben)
            
            let errors = tag.validate()
            if(errors.isEmpty) {
                modelContext.insert(tag)
            }
            return errors
        }
    }
}

#Preview {
    let schema = Schema([Aufgabe.self])
    let config = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: config)
    
    try! container.mainContext.delete(model:Aufgabe.self)
    for _ in 1...5 {
        let aufgabe = Aufgabe(bezeichnung: "Test123", bemerkung: "Hund", zeitpunktZumAbschliessen: Date().timeIntervalSince1970)
        container.mainContext.insert(aufgabe)
    }
   
    
    return TagAnlegenView()
        .modelContainer(container)
}
