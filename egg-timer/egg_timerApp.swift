//
//  ContentView.swift
//  egg-timer
//
//  Created by Merve Öğretmek on 1.03.2025.
//

import SwiftUI

@main
struct EggTimerApp: App{
    var body: some Scene {
        WindowGroup{
            ContentView()
        }
    }
}

struct ContentView: View {
    
    // Dictionary to store egg types and their corresponding times (in seconds)
    let eggTimes = [
        "Soft": 6 * 60,
        "Medium": 8 * 60,
        "Hard": 12 * 60
    ]
    
    @State private var timeRemaining = 0
    @State private var timerIsRunning = false
    
    // Timer publisher with 1 second intervals
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Egg Timer")
                .font(.largeTitle)
                .bold()
                .padding()
            
            // Display current time remaining
            Text(timeString(from: timeRemaining))
                .font(.system(size: 48, weight: .medium))
                .padding()
            
            // Three options for egg doneness
            HStack {
                
                // Soft egg image/button
                VStack {
                    Image("soft-boiled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            startTimer(for: "Soft")
                        }
                    Text("Soft")
                        .font(.headline)
                }
                .padding()
                
                // Medium egg image/button
                VStack {
                    Image("medium-boiled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            startTimer(for: "Medium")
                        }
                    Text("Medium")
                        .font(.headline)
                }
                .padding()
                
                // Hard egg image/button
                VStack {
                    Image("hard-boiled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            startTimer(for: "Hard")
                        }
                    Text("Hard")
                        .font(.headline)
                }
                .padding()
                              
            }
            
            // Possibly a stop/reset button
            Button(action: {
                resetTimer()
            }) {
                Text("Reset")
                    .font(.title2)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            }
        
        // Update the timer every second
        .onReceive(timer) { _ in
            if timerIsRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    
                    // Timer completed
                    timerIsRunning = false
                    
                    // Here it will be triggered
                }
            }
        }
    }
    
    // Start the timer based on the chosen egg type
    private func startTimer(for eggType: String) {
        if let totalSeconds = eggTimes[eggType] {
            timeRemaining = totalSeconds
            timerIsRunning = true
        }
    }
    
    // Reset the timer
    private func resetTimer() {
        timeRemaining = 0
        timerIsRunning = false
    }
    
    // Convert seconds into a mm:ss format
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
