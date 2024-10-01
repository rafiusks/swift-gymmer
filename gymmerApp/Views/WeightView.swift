import SwiftUI

struct WeightListView: View {
    @State private var newWeightValue: String = ""
    @State private var showHint = true
    @StateObject var weightViewModel = WeightViewModel() // ViewModel for managing weights

    var body: some View {
        VStack {
            // WeightChartView remains outside of the scrollable content to behave like a header
            WeightChartView()
                .ignoresSafeArea(edges: [.top, .horizontal])
                .frame(maxWidth: .infinity, maxHeight: 300, alignment: .top)
                .offset(y: -10)

            // Scrollable content below the chart
            ScrollView {
                VStack(spacing: 16) {
                    // Button to trigger the UIAlertController
                    Button(action: {
                        WeightInputAlert.show(title: "Add Weight", message: nil) { weightValue in
                            Task {
                                await weightViewModel.addWeight(weightValue: weightValue)
                                await weightViewModel.fetchWeights()
                            }
                        }
                    }) {
                        Text("Add Weight")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()

                    // List or other content here
                    List {
                        if showHint {
                            Text("Swipe left to delete or edit")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding()
                        }

                        HStack {
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

                                if let nextWeight = nextWeight {
                                    let difference = weight.weight - nextWeight.weight
                                    let percentageChange = (difference / nextWeight.weight) * 100
                                    
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
                                    Task {
                                        await weightViewModel.deleteWeight(weight: weight)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    // Edit logic
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .frame(minHeight: 400) // Ensure the List takes up enough space
                    .listStyle(PlainListStyle()) // Use a plain style for List to avoid grouped appearance
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
