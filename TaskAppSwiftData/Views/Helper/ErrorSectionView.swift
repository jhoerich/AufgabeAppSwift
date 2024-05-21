//
//  ErrorSectionView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import SwiftUI

struct ErrorSectionView: View {
    var errors : String
    var body: some View {
        if !errors.isEmpty {
            Section(header:Text("Fehler")) {
                Text("\(errors)")
                    .foregroundStyle(.red)
            }
        }
    }
}

