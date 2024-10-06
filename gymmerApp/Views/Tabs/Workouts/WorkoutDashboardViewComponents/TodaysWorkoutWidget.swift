import SwiftUI

struct TodaysWorkoutWidget: View {
    @State private var animatedProgress: Double = 0 // State for animated progress
    var workoutTitle: String = "Full Body Workout"
    var exercisesCount: Int = 11
    var totalMinutes: Int = 68
    var workoutsCompleted: Int = 2
    var workoutsGoal: Int = 3
    
    var progress: Double {
        return Double(workoutsCompleted) / Double(workoutsGoal)
    }
    
    var body: some View {
        NavigationLink(destination: WorkoutDetailView()) {
            ZStack {
                
                VStack{
                    
                    VStack{
                        
                        HStack {
                            Text("Today's Workout")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.systemGreen))
                                .font(.system(size: 12, weight: .bold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .background(Color.white) // Set the color of the line
                            .padding(.bottom, 20)
                        
                    }
                    
                    HStack {
                        // Progress Circle
                        ZStack {
                            Circle()
                                .stroke(Color(UIColor.systemGray4), lineWidth: 8)
                            
                            // Animated progress circle
                            Circle()
                                .trim(from: 0.0, to: animatedProgress)
                                .stroke(Color.green, lineWidth: 8)
                                .rotationEffect(Angle(degrees: -90))
                            
                            VStack {
                                Text("\(workoutsCompleted)/\(workoutsGoal)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                
                                Text("Workouts")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 100, height: 100)
                        .onAppear {
                            // Trigger animation on view appearance
                            withAnimation(.easeInOut(duration: 1)) {
                                animatedProgress = progress // Animate to the final progress value
                            }
                        }
                        
                        Spacer()
                        
                        // Workout Info
                        VStack(alignment: .leading, spacing: 4) {
                            Text("UP NEXT")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(workoutTitle)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("\(exercisesCount) EXERCISES, \(totalMinutes) MINUTES")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            
                        }
                        .padding(.trailing, 20)
                        
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 190)
        }
        .frame(height: 200, alignment: .top)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10) // Rounded corners
    }
}

#Preview {
    NavigationView {
        TodaysWorkoutWidget()
    }
}
