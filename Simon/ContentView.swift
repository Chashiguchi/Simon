//
//  ContentView.swift
//  Simon
//
//  Created by Chase Hashiguchi on 9/19/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Simon")
                .font(.system(size: 72))
        }
        .preferredColorScheme(.dark)
        .padding()
    }
}

#Preview {
    ContentView()
}
