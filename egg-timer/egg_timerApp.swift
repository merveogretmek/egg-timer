//
//  ContentView.swift
//  egg-timer
//
//  Created by Merve Öğretmek on 1.03.2025.
//

import SwiftUI
import AudioToolbox

extension Color {
    init(hex: String) {
        // Remove unwanted characters and convert to uppercase
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit), e.g., "F80"
            (a, r, g, b) = (255, (int >> 8) * 17,
                                   (int >> 4 & 0xF) * 17,
                                   (int & 0xF) * 17)
        case 6: // RGB (24-bit), e.g., "FF5733"
            (a, r, g, b) = (255, int >> 16,
                                   int >> 8 & 0xFF,
                                   int & 0xFF)
        case 8: // ARGB (32-bit), e.g., "CCFF5733"
            (a, r, g, b) = (int >> 24,
                                   int >> 16 & 0xFF,
                                   int >> 8 & 0xFF,
                                   int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


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
        ZStack {
            // Background color
            Color(hex: "#493d9e")
                .ignoresSafeArea()
            
            VStack {
                Text("Egg Timer")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .foregroundColor(Color(hex: "FFF2AF"))
                // Display current time remaining
                Text(timeString(from: timeRemaining))
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(Color(hex: "DAD2FF"))
                    .padding()
                
                // Three options for egg doneness
                HStack {
                    
                    // Soft egg image/button
                    VStack {
                        Image("soft-boiled")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .onTapGesture {
                                startTimer(for: "Soft")
                            }
                        Text("Soft")
                            .font(.headline)
                            .foregroundColor(Color(hex: "FFF2AF"))
                    }
                    
                    // Medium egg image/button
                    VStack {
                        Image("medium-boiled")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .onTapGesture {
                                startTimer(for: "Medium")
                            }
                        Text("Medium")
                            .font(.headline)
                            .foregroundColor(Color(hex: "FFF2AF"))
                    }
                    
                    // Hard egg image/button
                    VStack {
                        Image("hard-boiled")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .onTapGesture {
                                startTimer(for: "Hard")
                            }
                        Text("Hard")
                            .font(.headline)
                            .foregroundColor(Color(hex: "FFF2AF"))
                    }
                                  
                }
                
                // Possibly a stop/reset button
                Button(action: {
                    resetTimer()
                }) {
                    Text("Reset")
                        .font(.title2)
                        .padding()
                        .background(Color(hex: "B2A5FF"))
                        .foregroundColor(Color(hex: "493D9E"))
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
                        playAlarmSound() // Trigger the alarm sound
                    }
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
    
    // Play the alarm sound when the timer finishes
    private func playAlarmSound() {
        // Random built-in system sound
        AudioServicesPlaySystemSound(1005)
    }
}
