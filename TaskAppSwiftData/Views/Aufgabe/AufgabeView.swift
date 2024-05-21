//
//  TaskView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 13.05.24.
//

import SwiftUI
import SwiftData

struct AufgabeView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var aufgabe : Aufgabe
    
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
                Text(aufgabe.bezeichnung)
                    .font(.system(size: 18))
                HStack {
                    Text("Geplant: ")
                    Text(self.aufgabe.zeitpunktZumAbschliessen.asConvertedDateTimeString())
                }
                .font(.system(size: 11))
                .foregroundStyle(.gray)
                    
            }
            Spacer()
            Button {
                if !aufgabe.abgeschlossen {
                    aufgabe.abschliessen()
                }
            } label: {
                Image(systemName: aufgabe.abgeschlossen ? "checkmark.square.fill" : "square")
                    .foregroundStyle(.blue)
            }
        }.padding()
    }
}

#Preview {
    let schema = Schema([Aufgabe.self])
    let config = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: config)
    let aufgabe = Aufgabe(bezeichnung: "Hello Welt", bemerkung: "TEst123", zeitpunktZumAbschliessen: Date().timeIntervalSince1970, tags: [])
    return AufgabeView(aufgabe:aufgabe)
            .modelContainer(container)
}
