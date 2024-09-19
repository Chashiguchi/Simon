//
//  ContentView.swift
//  Simon
//
//  Created by Chase Hashiguchi on 9/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var colorDisplay = [ColorDisplay(color: .green),ColorDisplay(color: .red),ColorDisplay(color: .yellow),ColorDisplay(color: .blue)]
    var body: some View {
        VStack {
            Text("Simon")
                .font(.system(size: 72))
                .padding()
            HStack {
                colorDisplay[0]
                colorDisplay[1]
            }
            
            HStack {
                colorDisplay[2]
                colorDisplay[3]
            }
        }
        .preferredColorScheme(.dark)
        .padding()
    }
}

struct ColorDisplay: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(color)
            .frame(width: 100, height: 100)
            .padding()
    }
}

#Preview {
    ContentView()
}
