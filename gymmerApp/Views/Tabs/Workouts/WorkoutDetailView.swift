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
    @State private var showTimerModal = false // State to control the modal
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                headerSection
                Divider().padding(.horizontal)
                timerButton // Button to show the timer modal
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
        .sheet(isPresented: $showTimerModal) {
            TimerModal(isPresented: $showTimerModal)
                .presentationDetents([.medium]) // Control card modal size (optional)
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
    
    // Timer Button
    private var timerButton: some View {
        Button(action: {
            showTimerModal = true // Show the timer modal
        }) {
            Text("Open Timer")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
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
            if exercise.id == activeExerciseId {
                NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                    exerciseHeader(for: exercise)
                        .foregroundColor(.green) // Change the color to green when active
                }
            } else {
                exerciseHeader(for: exercise)
                    .foregroundColor(.primary)
            }
            
            if exercise.id == activeExerciseId {
                Divider().padding(.bottom)
                exerciseDetails(for: exercise)
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
            
            if exercise.id == activeExerciseId {
                Image(systemName: "chevron.right")
                    .foregroundColor(.green)
            }
        }
    }
    
    private func exerciseDetails(for exercise: Exercise) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("Weight (kg)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(width: 100)
                Text("Reps")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(width: 60)
            }
            
            if let exerciseLogIndex = workoutLog.firstIndex(where: { $0.exerciseId == exercise.id }) {
                ForEach(workoutLog[exerciseLogIndex].sets.indices, id: \.self) { setIndex in
                    exerciseSetView(for: exercise, setIndex: setIndex)
                }
            }
            
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
            }
        }
    }
    
    private func exerciseSetView(for exercise: Exercise, setIndex: Int) -> some View {
        HStack {
            Text("Set \(setIndex + 1)")
                .font(.subheadline)
            
            Spacer()
            
            if let exerciseLogIndex = workoutLog.firstIndex(where: { $0.exerciseId == exercise.id }) {
                TextField("Weight", value: $workoutLog[exerciseLogIndex].sets[setIndex].weight, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                
                TextField("Reps", value: $workoutLog[exerciseLogIndex].sets[setIndex].reps, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
                
                if setIndex > 0 {
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
                        .foregroundColor(.clear)
                }
            }
        }
    }
    
    private func addNewSet(for exercise: Exercise) {
        if let exerciseLogIndex = workoutLog.firstIndex(where: { $0.exerciseId == exercise.id }) {
            workoutLog[exerciseLogIndex].sets.append(ExerciseSet())
        }
    }
    
    private func removeSet(for exercise: Exercise, setIndex: Int) {
        if let exerciseLogIndex = workoutLog.firstIndex(where: { $0.exerciseId == exercise.id }) {
            workoutLog[exerciseLogIndex].sets.remove(at: setIndex)
        }
    }
    
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
                .shadow(radius: 5)
                .padding(.horizontal)
        }
    }
    
    private func initializeWorkoutLog() {
        workoutLog = exercises.map { exercise in
            ExerciseLog(exerciseId: exercise.id, sets: [ExerciseSet()])
        }
    }
    
    private func saveWorkoutLog() {
        print("Workout Log Saved: \(workoutLog)")
    }
}

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
