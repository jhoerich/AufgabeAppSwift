//
//  TabItemTextView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import SwiftUI

struct TabItemTextView: View {
    let imageName : String
    var text : String
    var body: some View {
        VStack {
            Image(systemName: self.imageName)
            Text(self.text)
                .font(.system(size: 10))
        }
    }
}
