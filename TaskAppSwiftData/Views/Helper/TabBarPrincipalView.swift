//
//  TabBarPrincipalView.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 21.05.24.
//

import SwiftUI

struct TabBarPrincipalView: View {
    let principal : String
    
    var body: some View {
        Text("\(self.principal)")
            .foregroundStyle(.blue)
    }
}
