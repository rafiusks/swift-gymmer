//
//  WeightzView.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 1/10/2024.
//

import SwiftUI

struct WeightListView: View {
    @StateObject var weightViewModel = WeightViewModel() // ViewModel for managing weights

    @State private var newWeightValue: String = ""

    var body: some View {
        VStack {
            TextField("Enter weight", text: $newWeightValue)
                .keyboardType(.decimalPad)
                .padding()

//            Button("Add Weight") {
//                if let weightValue = Float(newWeightValue) {
//                    Task {
//                        await weightViewModel.addWeight(weightValue: weightValue)
//                        newWeightValue = "" // Clear the input field after adding
//                    }
//                }
//            }
//            .padding()
            List {
                ForEach(weightViewModel.weights) { weight in
                    HStack {
                        Text("Weight: \(weight.weight, specifier: "%.2f") kg")
                        Spacer()
                        Text("Date: \(weight.date.formatted(.dateTime.year().month().day()))")
                    }
                    .onTapGesture {
                        // Update or interact with the weight item here
                    }
                }
//                .onDelete { indexSet in
//                    for index in indexSet {
//                        let weight = weightViewModel.weights[index]
//                        Task {
//                            await weightViewModel.deleteWeight(weight: weight)
//                        }
//                    }
//                }
            }
        }
        .onAppear {
            Task {
                await weightViewModel.fetchWeights() // Fetch weights when the view appears
            }
        }
    }
}

#Preview {
    WeightListView()
}
