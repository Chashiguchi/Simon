//
//  ContentView.swift
//  Simon
//
//  Created by Chase Hashiguchi on 9/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var colorDisplay = [ColorDisplay(color: .green),ColorDisplay(color: .red),ColorDisplay(color: .yellow),ColorDisplay(color: .blue)]
    @State private var flash = [false, false, false, false]
    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var index = 0
    @State private var sequence: [Int] = []
    @State private var startGame = false
    var body: some View {
        VStack {
            Text("Simon")
                .font(.system(size: 72))
                .padding(.top)
            HStack {
                colorDisplay[0]
                    .opacity(flash[0] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: 0)
                    }
                colorDisplay[1]
                    .opacity(flash[1] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: 1)
                    }
            }
            HStack {
                colorDisplay[2]
                    .opacity(flash[2] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: 2)
                    }
                colorDisplay[3]
                    .opacity(flash[3] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: 3)
                    }
            }
            Button(action: startNewGame) {
                Text(startGame ? "Restart" : "Start Game")
                    .font(.system(size: 24))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .onReceive(timer) { _ in
            if index < sequence.count {
                flashColorDisplay(index: sequence[index])
                index += 1
            } else {
                index = 0
                sequence.append(Int.random(in: 0...3))
            }
        }
    }
    func flashColorDisplay(index: Int) {
        flash[index].toggle()
        withAnimation(.easeInOut(duration: 0.5)) {
            flash[index].toggle()
        }
    }
    
    func startNewGame() {
        sequence = []
        index = 0
        startGame.toggle()
        if startGame {
            sequence.append(Int.random(in: 0...3))
        }
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
