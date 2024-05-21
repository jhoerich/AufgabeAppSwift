//
//  ContentView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 07.05.24.
//

import SwiftUI
import SwiftData
import Foundation

struct AufgabenView: View {
    @Environment(\.modelContext) private var modelContext
    @State var oeffneAufgabeErstellen : Bool = false
    @State var ausgewaehlteAufgabe : Aufgabe? = nil
    
    @Query var aufgaben : [Aufgabe]

    var body: some View {
        let gruppierteAufgaben = ErmittleGruppierteAufgabenNachDate(aufgaben: self.aufgaben)
        NavigationStack {
            List {
                let sortedList = gruppierteAufgaben.keys.sorted(by: { $0 < $1 } )
                ForEach(sortedList, id:\.self) {
                    aufgabeGruppiertNachDatum in
                    let aufgabenZumDatum = gruppierteAufgaben[aufgabeGruppiertNachDatum]!
                    
                    DisclosureGroup {
                        ForEach(aufgabenZumDatum, id: \.id){
                            aufgabe in
                            Button {
                                self.ausgewaehlteAufgabe = aufgabe
                            } label: {
                                AufgabeView(aufgabe: aufgabe)
                            }
                        }
                        .onDelete(perform: { offset in
                            offset.forEach {
                                index in
                                let aufgabe = aufgabenZumDatum[index]
                                modelContext.delete(aufgabe)
                                NotificationManager.instance.deleteScheduledNotification(aufgabe: aufgabe)
                            }
                        })
                    } label: {
                        HStack(alignment:.bottom) {
                            let anzahlAbgeschlossene = aufgabenZumDatum.filter { $0.abgeschlossen }.count
                            let anzahlAufgaben = aufgabenZumDatum.count
                                                                            
                            Text(aufgabeGruppiertNachDatum.asConvertedDateString())
                            Spacer()
                            Text("Abgeschlossen: \(anzahlAbgeschlossene)/\(anzahlAufgaben)")
                                .font(.system(size: 12))
                        }
                    }
                }.onDelete(perform: { offset in
                    offset.forEach {
                        index in
                        let aufgabeGruppiertNachDatum = sortedList[index]
                        let aufgabenZumDatum = gruppierteAufgaben[aufgabeGruppiertNachDatum]!
                        for aufgabeToDelete in aufgabenZumDatum {
                            modelContext.delete(aufgabeToDelete)
                            NotificationManager.instance.deleteScheduledNotification(aufgabe: aufgabeToDelete)
                        }
                    }
                })
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TabBarPrincipalView(principal: "Aufgaben")
                }
                ToolbarItem {
                    Button {
                        oeffneAufgabeErstellen.toggle()
                    } label: {
                        Label("Aufgabe erstellen", systemImage: "plus")
                
                    }
                }
            }
            .navigationDestination(item: self.$ausgewaehlteAufgabe) {
                item in
                AufgabeDetailView(aufgabe: item)
            }
            
        }.sheet(isPresented: $oeffneAufgabeErstellen, content: {
            AufgabeAnlegenView()
        })
        .tabItem {
            TabItemTextView(imageName: "pencil.and.list.clipboard", text: "Aufgaben")
        }
    }
    
    private func ErmittleGruppierteAufgabenNachDate(aufgaben: [Aufgabe]) -> [Date: [Aufgabe]] {
        return Dictionary(
            grouping: aufgaben,
            by: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: $0.zeitpunktZumAbschliessen))
                return dateFormatter.date(from: dateString)!
            })
    }
}


#Preview {
    let schema = Schema([Aufgabe.self])
    let configuration = ModelConfiguration(schema:schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: configuration)
    let aufgabe = Aufgabe(bezeichnung: "Test123", bemerkung: "Hund", zeitpunktZumAbschliessen: Date().timeIntervalSince1970, tags: [])
    try! container.mainContext.delete(model:Aufgabe.self)
    container.mainContext.insert(aufgabe)
    return AufgabenView()
        .modelContainer(container)
}
