//
//  TagsAendernView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import SwiftUI
import SwiftData

struct TagAendernView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var tag : Tag
    @State var bezeichnung : String = ""
    @State var zugeordneteAufgaben : [Aufgabe] = []
    
    @Query(sort:\Aufgabe.bezeichnung) var aufgaben : [Aufgabe]
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
    
    private func speichern() -> String {
        withAnimation {
            tag.bezeichnung = self.bezeichnung
            tag.aufgaben = self.zugeordneteAufgaben
           
            let errors = tag.validate()
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
    let tag = Tag(bezeichnung: "Filme")
    
    return TagAendernView(tag:tag)
        .modelContainer(container)
}
