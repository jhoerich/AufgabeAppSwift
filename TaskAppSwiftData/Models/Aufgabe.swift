//
//  Task.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 07.05.24.
//

import SwiftData
import Foundation

@Model
class Aufgabe : Hashable, Identifiable {
    let id : UUID = UUID()
    var bezeichnung : String = ""
    var bemerkung : String = ""
    
    let erzeugt : TimeInterval = Date().timeIntervalSince1970
    
    var zeitpunktZumAbschliessen : TimeInterval = Date().timeIntervalSince1970
    
    var zeitpunktAbgeschlossen : TimeInterval?
    
    @Relationship(inverse: \Tag.aufgaben) var tags : [Tag]?
    
    var abgeschlossen : Bool {
        return zeitpunktAbgeschlossen != nil
    }
    
    init(bezeichnung: String, bemerkung: String, zeitpunktZumAbschliessen: TimeInterval, tags : [Tag]) {
        self.id = UUID()
        self.bezeichnung = bezeichnung
        self.bemerkung = bemerkung
        self.erzeugt = Date().timeIntervalSince1970
        self.zeitpunktZumAbschliessen = zeitpunktZumAbschliessen
        self.tags = tags
    }
    
    func abschliessen() {
        zeitpunktAbgeschlossen = Date().timeIntervalSince1970
        NotificationManager.instance.deleteScheduledNotification(aufgabe: self)
    }
    
    func validate() -> String {
        guard !bezeichnung.isEmpty else {
            return "Es wurde keine Bezeichnung angegeben!"
        }
        return ""
    }
}
