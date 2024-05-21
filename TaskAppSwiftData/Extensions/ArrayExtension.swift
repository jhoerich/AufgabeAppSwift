//
//  ListExtension.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import Foundation

extension Array where Element : Identifiable {
    mutating func removeElement(element : Element) {
        if let index = self.firstIndex(where: { $0.id == element.id}) {
            self.remove(at: index)
        }
    }
    
    mutating func removeOrAddElement(element : Element) {
        if self.containsElement(element: element) {
            self.removeElement(element: element)
        } else {
            self.append(element)
        }
    }
    
    func containsElement(element : Element) -> Bool {
        return self.contains(where: {$0.id == element.id})
    }
}
