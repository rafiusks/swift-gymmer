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

            Button("Add Weight") {
                if let weightValue = Float(newWeightValue) {
                    Task {
                        await weightViewModel.addWeight(weightValue: weightValue)
                        newWeightValue = "" // Clear the input field after adding
                    }
                }
            }
            .padding()
            List {
                HStack {
                    Text("Date")
                    Spacer()
                    Text("Weight")
                    Spacer()
                    Text("Change")
                }
                
                let dateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    return formatter
                }()
                
                ForEach(weightViewModel.weights.indices, id: \.self) { index in
                    
                    let weight = weightViewModel.weights[index]
                    let nextWeight: Weight? = index < weightViewModel.weights.count - 1 ? weightViewModel.weights[index + 1] : nil

                    HStack {
                        Text(dateFormatter.string(from: weight.date))
                        Spacer()
                        Text("\(weight.weight, specifier: "%.2f") kg")
                        Spacer()

                        // Check if there's a next weight to compare to
                        if let nextWeight = nextWeight {
                            let difference = weight.weight - nextWeight.weight
                            let percentageChange = (difference / nextWeight.weight) * 100
                            
                            // Show an arrow up or down based on weight change
                            if difference > 0 {
                                Text("\(percentageChange, specifier: "%.2f")% ↑")
                                    .foregroundColor(.red) // Red for increase
                            } else if difference < 0 {
                                Text("\(percentageChange, specifier: "%.2f")% ↓")
                                    .foregroundColor(.green) // Green for decrease
                            } else {
                                Text("No change")
                            }
                        } else {
                            Text("N/A")
                        }
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
