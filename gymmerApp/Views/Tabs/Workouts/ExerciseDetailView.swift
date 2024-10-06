//
//  ExerciseDetailView.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 6/10/2024.
//


import SwiftUI

struct ExerciseDetailView: View {
    var exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(exercise.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Add more details related to the exercise, like description, tips, etc.
            Text("Description:")
                .font(.title2)
                .fontWeight(.semibold)
            Text("This is where you can provide a detailed description of the exercise, instructions on form, common mistakes, and additional tips.")
                .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}