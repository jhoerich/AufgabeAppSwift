//
//  TextFieldRemoveButton.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 14.05.24.
//

import SwiftUI

struct TextFieldRemoveButton: View {
    let textFieldTitle : String
    @Binding var text : String
    
    var body: some View {
        HStack {
            TextField(self.textFieldTitle, text: self.$text, axis: .vertical)
            if !self.text.isEmpty {
                Button {
                    self.text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
