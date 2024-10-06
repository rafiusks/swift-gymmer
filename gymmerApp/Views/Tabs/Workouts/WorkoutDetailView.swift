import SwiftUI

struct WorkoutDetailView: View {
    var workoutTitle: String = "Full Body Workout"
    var exercises: [Exercise] = [
        Exercise(name: "Squats"),
        Exercise(name: "Push-ups"),
        Exercise(name: "Deadlifts")
    ]
    
    @State private var workoutLog: [ExerciseLog] = []
    @State private var activeExerciseId: UUID? // Track the currently active exercise
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                headerSection
                Divider().padding(.horizontal)
                exerciseListSection
                Spacer()
                saveWorkoutButton
            }
        }
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            initializeWorkoutLog()
            // Set the first exercise as active on load
            activeExerciseId = exercises.first?.id
        }
    }
    
    // Separate header into its own View
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(workoutTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    // Exercise list
    private var exerciseListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(exercises) { exercise in
                exerciseCard(for: exercise)
                    .background(Color(UIColor.systemGray6)) // Use systemGray6 for all exercises
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .opacity(exercise.id == activeExerciseId ? 1 : 0.5) // Apply opacity based on active status
                    .frame(maxWidth: .infinity) // Ensure full width even when collapsed
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) { // Faster animation (0.25s)
                            activeExerciseId = exercise.id // Set this exercise as active when tapped
                        }
                    }
            }
        }
        .padding(.horizontal)
    }
    
    private func exerciseCard(for exercise: Exercise) -> some View {
        VStack(alignment: .leading) {
            // If the exercise is active, allow navigation. Otherwise, disable it.
            if exercise.id == activeExerciseId {
                NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                    exerciseHeader(for: exercise)
                        .foregroundColor(.green) // Change the color to green when active
                }
            } else {
                // Just the header for inactive exercises, no navigation
                exerciseHeader(for: exercise)
                    .foregroundColor(.primary) // Default color for inactive exercises
            }
            
            // Expand/collapse the rest of the card based on active state
            if exercise.id == activeExerciseId {
                Divider().padding(.bottom)
                
                // Add a header for "Weight" and "Reps"
                HStack {
                    Spacer()
                    Text("Weight (kg)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(width: 100, alignment: .center)
                    Text("Reps")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(width: 60, alignment: .center)
                    Spacer().frame(width: 40)
                }
                
                if let exerciseLogIndex = workoutLog.firstIndex(where: { $0.exerciseId == exercise.id }) {
                    ForEach(workoutLog[exerciseLogIndex].sets.indices, id: \.self) { setIndex in
                        exerciseSetView(for: exercise, setIndex: setIndex)
                    }
                }
                
                // Add Set Button (aligned to the left)
                Button(action: {
                    withAnimation {
                        addNewSet(for: exercise)
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Set")
                    }
                    .foregroundColor(.green)
                    .padding(.vertical, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Align button to the left
            }
        }
        .padding()
    }
    
    private func exerciseHeader(for exercise: Exercise) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("3 sets of 8-12 reps, @30kg")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Show chevron if the exercise is active
            if exercise.id == activeExerciseId {
                Image(systemName: "chevron.right")
                    .foregroundColor(.green) // Make chevron green for active
            }
        }
    }
    
    private func exerciseSetView(for exercise: Exercise, setIndex: Int) -> some View {
        HStack {
            Text("Set \(setIndex + 1)")
                .font(.subheadline)
            
            Spacer()
            
            if let exerciseLogIndex = workoutLog.firstIndex(where: { $0.exerciseId == exercise.id }) {
                // Ensure there are enough sets in the workout log to prevent crashes
                if workoutLog[exerciseLogIndex].sets.indices.contains(setIndex) {
                    // Weight TextField (disable when not active)
                    TextField("Weight", value: $workoutLog[exerciseLogIndex].sets[setIndex].weight, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .disabled(exercise.id != activeExerciseId) // Disable when not active
                    
                    // Reps TextField (disable when not active)
                    TextField("Reps", value: $workoutLog[exerciseLogIndex].sets[setIndex].reps, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                        .disabled(exercise.id != activeExerciseId) // Disable when not active
                    
                    // Remove set button (except for the first set)
                    if setIndex > 0 && exercise.id == activeExerciseId { // Only show for active exercise
                        Button(action: {
                            withAnimation {
                                removeSet(for: exercise, setIndex: setIndex)
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    } else {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.clear) // Placeholder to maintain alignment
                    }
                }
            }
        }
    }
    
    // Add a new set
    private func addNewSet(for exercise: Exercise) {
        if let exerciseLogIndex = workoutLog.firstIndex(where: { $0.exerciseId == exercise.id }) {
            workoutLog[exerciseLogIndex].sets.append(ExerciseSet())
        }
    }
    
    // Remove a specific set
    private func removeSet(for exercise: Exercise, setIndex: Int) {
        if let exerciseLogIndex = workoutLog.firstIndex(where: { $0.exerciseId == exercise.id }) {
            workoutLog[exerciseLogIndex].sets.remove(at: setIndex)
        }
    }
    
    // Save Workout Button
    private var saveWorkoutButton: some View {
        Button(action: {
            saveWorkoutLog()
        }) {
            Text("Save Workout")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.green)
                .cornerRadius(10)
                .shadow(radius: 5) // Add a subtle shadow for better depth
                .padding(.horizontal)
        }
    }
    
    // Initialize workout log with empty values
    private func initializeWorkoutLog() {
        workoutLog = exercises.map { exercise in
            ExerciseLog(exerciseId: exercise.id, sets: [ExerciseSet()]) // Start with one set
        }
    }
    
    // Save workout log (placeholder)
    private func saveWorkoutLog() {
        print("Workout Log Saved: \(workoutLog)")
    }
}

// Models
struct Exercise: Identifiable {
    var id = UUID()
    var name: String
}

struct ExerciseLog {
    var exerciseId: UUID
    var sets: [ExerciseSet]
}

struct ExerciseSet {
    var weight: Double? = nil
    var reps: Int? = nil
}

#Preview {
    NavigationView {
        WorkoutDetailView()
    }
}
