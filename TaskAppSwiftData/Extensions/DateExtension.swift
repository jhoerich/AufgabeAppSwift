//
//  DateExtension.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 17.05.24.
//

import Foundation

extension Date {
    func asConvertedDateString() -> String {
        return asFormated(format: "dd.MM.yyyy")
    }
    
    private func asFormated(format : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
