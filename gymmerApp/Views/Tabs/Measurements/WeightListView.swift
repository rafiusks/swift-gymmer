import SwiftUI

struct WeightListView: View {
    @State private var newWeightValue: String = ""
    @StateObject var weightViewModel = WeightViewModel() // ViewModel for managing weights
    
    var body: some View {
        ZStack {
            VStack {
                // WeightChartView remains outside of the scrollable content to behave like a header
                WeightChartView()
                    .ignoresSafeArea(edges: [.top, .horizontal])
                    .frame(maxWidth: .infinity, maxHeight: 220, alignment: .top)
                    .offset(y: -10)
                
                // Scrollable content below the chart
                ScrollView {
                    VStack(spacing: 16) {
                        List {
                            HStack {
                                Text("Date").bold().frame(width: 120)
                                Spacer()
                                Text("Weight").bold().frame(width: 120)
                                Spacer()
                                Text("Change").bold().frame(width: 120)
                            }
                            
                            // Date Formatter
                            let dateFormatter: DateFormatter = {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yy"
                                return formatter
                            }()
                            
                            // Simplified the ForEach block
                            ForEach(Array(weightViewModel.weights.enumerated()), id: \.offset) { index, weight in
                                let nextWeight: Weight? = nextWeightForIndex(index: index, weights: weightViewModel.weights)
                                
                                HStack {
                                    Text(dateFormatter.string(from: weight.date)).font(.subheadline).frame(width: 120)
                                    Spacer()
                                    Text("\(weight.weight, specifier: "%.2f") \(WeightUnit().unit)").font(.subheadline).frame(width: 120)
                                    Spacer()
                                    
                                    if let nextWeight = nextWeight {
                                        let percentageChange = calculatePercentageChange(current: weight, next: nextWeight)
                                        Text(percentageChange)
                                            .foregroundColor(percentageChangeColor(percentageChange))
                                            .font(.caption)
                                            .bold()
                                            .frame(width: 120)
                                    } else {
                                        Text("N/A")
                                            .font(.caption)
                                            .bold()
                                            .frame(width: 120)
                                    }
                                }
                                .swipeActions(edge: .trailing) {
                                    deleteAndEditActions(weight: weight)
                                }
                            }
                        }
                        .frame(minHeight: 600) // Ensure the List takes up enough space
                        .listStyle(PlainListStyle())
                    }
                }
            }
            
            // Floating button with a plus sign
            floatingAddButton()
        }
        .onAppear {
            Task {
                await weightViewModel.fetchWeights() // Fetch weights when the view appears
            }
        }
    }
    
    // MARK: - Helper functions
    
    func nextWeightForIndex(index: Int, weights: [Weight]) -> Weight? {
        return index < weights.count - 1 ? weights[index + 1] : nil
    }
    
    func calculatePercentageChange(current: Weight, next: Weight) -> String {
        let difference = current.weight - next.weight
        let percentageChange = (difference / next.weight) * 100
        let formattedChange = String(format: "%.2f", percentageChange)
        let direction = difference > 0 ? "↑" : "↓"
        return "\(formattedChange)% \(direction)"
    }
    
    func percentageChangeColor(_ percentageChange: String) -> Color {
        return percentageChange.contains("↑") ? .red : .green
    }
    
    func deleteAndEditActions(weight: Weight) -> some View {
        Group {
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
    
    func floatingAddButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    WeightInputAlert.show(title: "Add Weight", message: nil) { weightValue in
                        Task {
                            await weightViewModel.addWeight(weightValue: weightValue)
                            await weightViewModel.fetchWeights()
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
                .listStyle(PlainListStyle())
            }
        }
    }
}

#Preview {
    WeightListView()
}
