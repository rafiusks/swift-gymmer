import SwiftUI
import AVFoundation
import UserNotifications

struct TimerModal: View {
    @Binding var isPresented: Bool
    @State private var remainingTime: TimeInterval = 300
    @State private var isTimerRunning = false
    @State private var timerComplete = false
    @State private var customMinutes: String = "0"
    @State private var customSeconds: String = "0"
    @State private var showError = false
    @State private var startTime: Date? = nil // To store the start time
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Workout Timer")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Circular progress indicator
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(remainingTime / 300))
                    .stroke(Color.green, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: remainingTime)
                
                Text(timerComplete ? "Time's up!" : timeString(from: remainingTime))
                    .font(.largeTitle)
                    .monospacedDigit()
            }
            .frame(width: 150, height: 150)
            
            HStack {
                VStack {
                    Text("Minutes")
                    TextField("0", text: $customMinutes)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                        .onChange(of: customMinutes) { newValue in
                            customMinutes = newValue.filter { "0123456789".contains($0) }
                        }
                }
                
                VStack {
                    Text("Seconds")
                    TextField("0", text: $customSeconds)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                        .onChange(of: customSeconds) { newValue in
                            customSeconds = newValue.filter { "0123456789".contains($0) }
                        }
                }
                
                // Set timer button
                Button(action: setCustomTimerAndStart) {
                    Text("Set Timer")
                        .padding()
                        .background(isTimerRunning ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .disabled(isTimerRunning)
                }
            }
            
            if showError {
                Text("Invalid time. Please enter valid minutes and seconds.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            HStack {
                Button(action: {
                    isTimerRunning.toggle()
                    if isTimerRunning {
                        startTimer()
                    } else {
                        pauseTimer()
                    }
                }) {
                    Text(isTimerRunning ? "Pause" : "Start")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isTimerRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                Button(action: resetTimer) {
                    Text("Reset")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            
            Button(action: {
                isPresented = false
            }) {
                Text("Close")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .onAppear {
            print("On appear")
            restoreTimerState()
            requestNotificationPermission()
        }
        .onReceive(timer) { _ in
            if isTimerRunning && remainingTime > 0 {
                remainingTime -= 1
                saveTimerState()
            } else if remainingTime == 0 && !timerComplete {
                timerComplete = true
                isTimerRunning = false
                playSystemSound()
                scheduleNotification()
            }
        }
    }
    
    // Start the timer based on custom user input
    private func setCustomTimerAndStart() {
        let minutes = Double(customMinutes) ?? 0
        let seconds = Double(customSeconds) ?? 0
        
        if minutes >= 0 && seconds >= 0 && (minutes > 0 || seconds > 0) && seconds < 60 {
            remainingTime = (minutes * 60) + seconds
            timerComplete = false
            isTimerRunning = true
            showError = false
            startTime = Date() // Set the start time
            saveTimerState()
            scheduleNotification() // Schedule the notification when the timer starts
        } else {
            showError = true
        }
    }
    
    private func resetTimer() {
        remainingTime = 300
        customMinutes = "0"
        customSeconds = "0"
        isTimerRunning = false
        timerComplete = false
        showError = false
        startTime = nil // Reset the start time
        saveTimerState()
        removeNotification() // Remove any scheduled notification
    }
    
    private func timeString(from interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func playSystemSound() {
        AudioServicesPlaySystemSound(1005)
    }
    
    // Schedule the notification for the remaining time
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Workout Timer"
        content.body = "Time's up!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: remainingTime, repeats: false)
        
        let request = UNNotificationRequest(identifier: "com.ravmedia.timer", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Remove the notification when the timer is cancelled or reset
    private func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["com.ravmedia.timer"])
    }
    
    private func requestNotificationPermission() {
        Task {
            let center = UNUserNotificationCenter.current()
            do {
                if try await center.requestAuthorization(options: [.alert, .sound, .badge]) == true {
                    print("success")
                } else {
                    print("fail")
                }
                
            } catch {
                print("Error")
            }
        }
    }
    
    // Save the current timer state to UserDefaults
    private func saveTimerState() {
        UserDefaults.standard.set(remainingTime, forKey: "RemainingTime")
        if let startTime = startTime {
            UserDefaults.standard.set(startTime, forKey: "StartTime")
        }
    }
    
    // Restore the timer state when the app returns
    private func restoreTimerState() {
        let savedRemainingTime = UserDefaults.standard.double(forKey: "RemainingTime")
        let savedStartTime = UserDefaults.standard.object(forKey: "StartTime") as? Date
        
        if let savedStartTime = savedStartTime {
            let elapsedTime = Date().timeIntervalSince(savedStartTime)
            
            remainingTime = max(savedRemainingTime - elapsedTime, 0)
            
            if remainingTime > 0 {
                // Timer is still running
                isTimerRunning = true
                startTime = savedStartTime
            } else {
                // Timer is completed, but we are returning after it ended
                remainingTime = 0
                timerComplete = true
                isTimerRunning = false
                // Do not trigger alarm or notification
            }
        }
    }
    
    private func startTimer() {
        startTime = Date()
        saveTimerState()
        scheduleNotification()
    }
    
    private func pauseTimer() {
        saveTimerState()
        removeNotification()
    }
}
