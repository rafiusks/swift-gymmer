//
//  WorkoutProgressView.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 2/10/2024.
//


import SwiftUI

struct WorkoutProgressWidget: View {
    // Sample data for the workout progress
    var progress: Double = 0.65 // 65% progress
    var exercisesLeft: Int = 12

    var body: some View {
        HStack {
            // Text Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Workout Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(exercisesLeft) Exercise left")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()

            // Circular Progress View
            ZStack {
                // Circular progress background
                Circle()
                    .stroke(lineWidth: 8)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                // Circular progress foreground
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(AngularGradient(gradient: Gradient(colors: [Color.green, Color.blue]), center: .center), lineWidth: 8)
                    .rotationEffect(Angle(degrees: 270)) // Start at the top
                    .animation(.easeInOut, value: progress) // Smooth animation
                
                // Progress percentage text
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(width: 50, height: 50)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(20) // Rounded corners
        .shadow(radius: 5) // Shadow effect
    }
}

#Preview {
    WorkoutProgressWidget()
}
