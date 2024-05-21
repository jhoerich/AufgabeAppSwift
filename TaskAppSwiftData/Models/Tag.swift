//
//  Task.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import Foundation
import SwiftData

@Model
class Tag : Hashable, Identifiable {
    let id : UUID = UUID()
    var bezeichnung : String = ""
    @Relationship var aufgaben : [Aufgabe]?
    
    init(bezeichnung : String) {
        self.id = UUID()
        self.bezeichnung = bezeichnung
        self.aufgaben = []
    }
    
    func aufgabenHinzufuegen(aufgaben: [Aufgabe]) {
        self.aufgaben?.append(contentsOf: aufgaben)
    }
    
    func validate() -> String {
        guard !bezeichnung.isEmpty else {
            return "Es wurde keine Bezeichnung angegeben!"
        }
        return ""
    }
}
