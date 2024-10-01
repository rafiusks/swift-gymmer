//
//  WeightzView.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 1/10/2024.
//

import SwiftUI

struct WeightListView: View {
    @State private var newWeightValue: String = ""
    @State private var showHint = true
    
    @StateObject var weightViewModel = WeightViewModel() // ViewModel for managing weights

    var body: some View {
        
        VStack {
            
            WeightChartView()
            
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
                
                if showHint {
                        Text("Swipe left to delete or edit")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding()
                    }
                
                HStack {
                    //alignment leading
                    Text("Date").bold().frame(width: 120)
                    
                    
                    Spacer()
                    Text("Weight").bold().frame(width: 120)
                    Spacer()
                    Text("Change").bold().frame(width: 120)
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
                        Text(dateFormatter.string(from: weight.date)).font(.subheadline).frame(width: 120)
                        Spacer()
                        Text("\(weight.weight, specifier: "%.2f") kg").font(.subheadline).frame(width: 120)
                        Spacer()

                        // Check if there's a next weight to compare to
                        if let nextWeight = nextWeight {
                            let difference = weight.weight - nextWeight.weight
                            let percentageChange = (difference / nextWeight.weight) * 100
                            
                            // Show an arrow up or down based on weight change
                            if difference > 0 {
                                Text("\(percentageChange, specifier: "%.2f")% ↑")
                                    .foregroundColor(.red) // Red for increase
                                    .font(.caption)
                                    .bold()
                                    .frame(width: 120)
                            } else if difference < 0 {
                                Text("\(percentageChange, specifier: "%.2f")% ↓")
                                    .foregroundColor(.green) // Green for decrease
                                    .font(.caption)
                                    .bold()
                                    .frame(width: 120)
                            } else {
                                Text("No change")
                            }
                        } else {
                            Text("N/A")
                                .font(.caption)
                                .bold()
                                .frame(width: 120)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // Action for deleting the weight
                                Task {
                                    await weightViewModel.deleteWeight(weight: weight)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                // Action for editing the weight
                                // Trigger the edit logic here (e.g., showing an edit modal)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let weight = weightViewModel.weights[index]
                        Task {
                            await weightViewModel.deleteWeight(weight: weight)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await weightViewModel.fetchWeights() // Fetch weights when the view appears
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                   showHint = false
               }
        }
    }
}

#Preview {
    WeightListView()
}
