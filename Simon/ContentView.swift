//
//  ContentView.swift
//  Simon
//
//  Created by Chase Hashiguchi on 9/19/24.
//

import SwiftUI
import AVFoundation
import UIKit

struct ContentView: View {
    @State private var colorDisplay = [ColorDisplay(color: .green),ColorDisplay(color: .red),ColorDisplay(color: .yellow),ColorDisplay(color: .blue)]
    @State private var flash = [false, false, false, false]
    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var index = 0
    @State private var highScore = 0
    @State private var sequence: [Int] = []
    @State private var userInput: [Int] = []
    @State private var startGame = false
    @State private var gameOver = false
    @State private var isFlashingSequence = false
    var audioPlayer: AVAudioPlayer?
    var body: some View {
        VStack {
            Text("Simon")
                .font(.custom("Impact", size: 72))
                .padding(.top)
            Spacer()
            Text("Score: \(sequence.count)")
                .font(.custom("Impact", size: 36))
                .padding()
            Text("High Score: \(highScore)")
                .font(.custom("Impact", size: 24))
            HStack {
                colorDisplay[0]
                    .opacity(flash[0] ? 1 : 0.4)
                    .onTapGesture {
                        handleUserInput(index: 0)
                    }
                colorDisplay[1]
                    .opacity(flash[1] ? 1 : 0.4)
                    .onTapGesture {
                        handleUserInput(index: 1)
                    }
            }
            HStack {
                colorDisplay[2]
                    .opacity(flash[2] ? 1 : 0.4)
                    .onTapGesture {
                        handleUserInput(index: 2)
                    }
                colorDisplay[3]
                    .opacity(flash[3] ? 1 : 0.4)
                    .onTapGesture {
                        handleUserInput(index: 3)
                    }
            }
            Spacer()
            Button(action: startNewGame) { // toggles between Start game and restart
                Text(startGame ? "Restart" : "Start Game")
                    .font(.system(size: 24))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            if gameOver {
                Text("Game Over")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .onReceive(timer) { _ in
            if startGame && !gameOver && isFlashingSequence {
                if index < sequence.count {
                    flashColorDisplay(index: sequence[index])
                    index += 1
                } else {
                    index = 0
                    userInput = []
                    isFlashingSequence = false
                }
            }
        }
    }
    func flashColorDisplay(index: Int) { // makes the button light up and turn off
        flash[index].toggle()
        withAnimation(.easeInOut(duration: 0.5)) {
            flash[index].toggle()
        }
    }
    
    func startNewGame() { // starts the game by setting game over to false and set index to 0
        sequence = []
        userInput = []
        index = 0
        startGame.toggle()
        gameOver = false
        if startGame { // when the game is started play a random color and play the sound
            sequence.append(Int.random(in: 0...3))
            isFlashingSequence = true
            startFlashingSequence()
            SoundManager.shared.playSound(named: "Start")
        }
    }
    
    func handleUserInput(index: Int) { // makes user repeat the sequence to continue
        guard startGame, !gameOver, !isFlashingSequence else {return} // guard make it so the code only proceeds under certain conditions
        userInput.append(index)
        SoundManager.shared.playSound(named: "\(index)") // plays the sound for the colored buttons
        flashColorDisplay(index: index)
        if userInput.last != sequence[userInput.count - 1] { // ends game when you make a mistake
            gameOver = true
            SoundManager.shared.playSound(named: "Lose") // plays the sound for when you lose
            updateHighScore() // updates high score after the game ends
        } else if userInput.count == sequence.count { // adds random color to the sequence to continue
            userInput = []
            self.index = 0
            addNewColorToSequence()
            isFlashingSequence = true
            startFlashingSequence()
        }
    }
    
    func addNewColorToSequence() {
        sequence.append(Int.random(in: 0...3))
    }
    
    func startFlashingSequence() {
        isFlashingSequence = true
        timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    }
    
    func updateHighScore() {
        if sequence.count > highScore {
            highScore = sequence.count
            SoundManager.shared.playSound(named: "HighScore")
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

class SoundManager { // made class to play sounds
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
