import SwiftUI

struct WorkoutDashboardView: View {
    @State private var todayWorkout: String? = "Leg Day" // Example workout for today, dynamic loading later
    @State private var workouts = ["Leg Day", "Push Day", "Pull Day", "Cardio"] // Example workouts
    @State private var selectedWorkout: String? = nil
    
    var body: some View {
        NavigationView { // <-- Add NavigationView here
            VStack(spacing: 24) {
                
                TodaysWorkoutWidget()
                
                // Section: Quick Select Pre-existing Workout
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick Start Workout")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(workouts, id: \.self) { workout in
                                Button(action: {
                                    selectedWorkout = workout
                                }) {
                                    Text(workout)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                
                // Section: Create New Workout
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create a New Workout")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        // Create workout action
                    }) {
                        Text("New Workout")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                
                // Section: Stats
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Stats")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        StatView(title: "Calories Burned", value: "450 kcal")
                        StatView(title: "Workouts Completed", value: "15")
                        StatView(title: "Hours Trained", value: "10 hrs")
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Workout Dashboard")
        }
    }
}

// Reusable Stat View Component
struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
                .bold()
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    WorkoutDashboardView()
}
