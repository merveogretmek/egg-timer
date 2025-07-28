//
//  ContentView.swift
//  egg-timer
//
//  Created by Merve Öğretmek on 1.03.2025.
//

import SwiftUI
import AudioToolbox
import AVFoundation

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
    @State private var totalTime = 0
    @State private var timerIsRunning = false
    @State private var isPaused = false
    @State private var startTime: Date?
    @State private var timerCancellable: Timer?
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showingCustomTimer = false
    @State private var customMinutes = 5
    @State private var customSeconds = 0
    
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
                // Circular progress indicator with time display
                ZStack {
                    Circle()
                        .stroke(Color(hex: "B2A5FF").opacity(0.3), lineWidth: 8)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: progressValue)
                        .stroke(Color(hex: "B2A5FF"), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.1), value: progressValue)
                    
                    VStack {
                        Text(timeString(from: timeRemaining))
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(Color(hex: "DAD2FF"))
                        
                        if timerIsRunning {
                            Text(isPaused ? "PAUSED" : "COOKING")
                                .font(.caption)
                                .foregroundColor(Color(hex: "FFF2AF"))
                        }
                    }
                }
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
                
                // Custom timer button
                Button(action: {
                    showingCustomTimer = true
                }) {
                    HStack {
                        Image(systemName: "timer")
                            .font(.title2)
                        Text("Custom Timer")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(hex: "FFF2AF").opacity(0.2))
                    .foregroundColor(Color(hex: "FFF2AF"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "FFF2AF"), lineWidth: 1)
                    )
                }
                .padding()
                .sheet(isPresented: $showingCustomTimer) {
                    CustomTimerView(
                        minutes: $customMinutes,
                        seconds: $customSeconds,
                        onStart: { minutes, seconds in
                            let totalSeconds = minutes * 60 + seconds
                            startCustomTimer(seconds: totalSeconds)
                            showingCustomTimer = false
                        }
                    )
                }
                
                // Control buttons
                HStack(spacing: 20) {
                    if timerIsRunning {
                        Button(action: {
                            togglePause()
                        }) {
                            Text(isPaused ? "Resume" : "Pause")
                                .font(.title2)
                                .padding()
                                .background(Color(hex: "FFF2AF"))
                                .foregroundColor(Color(hex: "493D9E"))
                                .cornerRadius(8)
                        }
                    }
                    
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
                }
                .padding()
                
                }
            
            .onDisappear {
                stopTimer()
            }
        }
    }
    
    // Computed property for progress value
    private var progressValue: Double {
        guard totalTime > 0 else { return 0 }
        return 1.0 - (Double(timeRemaining) / Double(totalTime))
    }
    
    // Start the timer based on the chosen egg type
    private func startTimer(for eggType: String) {
        if let totalSeconds = eggTimes[eggType] {
            stopTimer()
            timeRemaining = totalSeconds
            totalTime = totalSeconds
            timerIsRunning = true
            isPaused = false
            startTime = Date()
            scheduleTimer()
        }
    }
    
    // Start custom timer with specified seconds
    private func startCustomTimer(seconds: Int) {
        stopTimer()
        timeRemaining = seconds
        totalTime = seconds
        timerIsRunning = true
        isPaused = false
        startTime = Date()
        scheduleTimer()
    }
    
    // More accurate timer using DispatchSourceTimer
    private func scheduleTimer() {
        guard let startTime = startTime else { return }
        
        timerCancellable = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !self.isPaused && self.timerIsRunning {
                let elapsed = Date().timeIntervalSince(startTime)
                let remaining = self.totalTime - Int(elapsed)
                
                if remaining <= 0 {
                    self.timeRemaining = 0
                    self.timerIsRunning = false
                    self.stopTimer()
                    self.playAlarmSound()
                    self.triggerHapticFeedback()
                } else {
                    self.timeRemaining = remaining
                }
            }
        }
    }
    
    // Toggle pause/resume
    private func togglePause() {
        isPaused.toggle()
        if !isPaused {
            // Recalculate start time when resuming
            let elapsed = totalTime - timeRemaining
            startTime = Date().addingTimeInterval(-Double(elapsed))
        }
    }
    
    // Stop and clean up timer
    private func stopTimer() {
        timerCancellable?.invalidate()
        timerCancellable = nil
    }
    
    // Reset the timer
    private func resetTimer() {
        stopTimer()
        timeRemaining = 0
        totalTime = 0
        timerIsRunning = false
        isPaused = false
        startTime = nil
    }
    
    // Convert seconds into a mm:ss format
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Play the alarm sound when the timer finishes
    private func playAlarmSound() {
        // Play system sound with vibration
        AudioServicesPlaySystemSound(1005)
        
        // Try to play a longer alarm sound if available
        guard let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            // Fallback to system sounds
            for _ in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...0.5)) {
                    AudioServicesPlaySystemSound(1005)
                }
            }
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = 2
            audioPlayer?.play()
        } catch {
            AudioServicesPlaySystemSound(1005)
        }
    }
    
    // Add haptic feedback
    private func triggerHapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        // Multiple haptic pulses
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            impactFeedback.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            impactFeedback.impactOccurred()
        }
    }
}

struct CustomTimerView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    let onStart: (Int, Int) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Set Custom Timer")
                    .font(.title)
                    .bold()
                    .padding()
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Minutes")
                            .font(.headline)
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute)").tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                    }
                    
                    VStack {
                        Text("Seconds")
                            .font(.headline)
                        Picker("Seconds", selection: $seconds) {
                            ForEach(0..<60) { second in
                                Text("\(second)").tag(second)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                    }
                }
                
                Button(action: {
                    if minutes > 0 || seconds > 0 {
                        onStart(minutes, seconds)
                    }
                }) {
                    Text("Start Timer")
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(minutes == 0 && seconds == 0)
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
