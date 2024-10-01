import Charts
import SwiftUI

struct WeightChartView: View {
    @StateObject var weightViewModel = WeightViewModel()
    @State private var selectedWeight: Weight?
    
    var lastTenWeights: [Weight] {
        Array(weightViewModel.weights.prefix(10).reversed())
    }
    
    var latestWeight: Weight? {
        lastTenWeights.last
    }
    
    var formattedDate: String {
        guard let latestWeight = latestWeight else { return "Unknown Date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: latestWeight.date)
    }
    
    var minWeight: Float {
        lastTenWeights.map { $0.weight }.min() ?? 0
    }
    
    var maxWeight: Float {
        lastTenWeights.map { $0.weight }.max() ?? 100
    }
    
    var firstWeight: Weight? {
        lastTenWeights.last // Oldest weight
    }
    
    var lastWeight: Weight? {
        lastTenWeights.first // Latest weight
    }
    
    var body: some View {
        VStack {
            weightChart
            selectedWeightInfo
            weightTitle
        }
        .onAppear {
            Task {
                await weightViewModel.fetchWeights()
            }
        }
    }
    
    var weightTitle: some View {
        Group {
            if let latestWeight = latestWeight {
                Text("Last update: \(latestWeight.weight, specifier: "%.2f") kg, \(formattedDate)")
                    .font(.headline)
                    .padding()
            } else {
                Text("No weight data available")
                    .font(.headline)
                    .padding()
            }
        }
    }
    
    var weightChart: some View {
        Chart {
            ForEach(lastTenWeights) { weight in
                AreaMark(
                    x: .value("Date", weight.date),
                    yStart: .value("Min", minWeight - 1),
                    yEnd: .value("Weight", weight.weight)
                )
                .foregroundStyle(
                    .linearGradient(
                        colors: [.blue.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(
                    x: .value("Date", weight.date),
                    y: .value("Weight", weight.weight)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 2))
                .foregroundStyle(.blue)
            }
            
            if let firstWeight = firstWeight {
                PointMark(
                    x: .value("Date", firstWeight.date),
                    y: .value("Weight", firstWeight.weight)
                )
                .symbolSize(50)
                .foregroundStyle(.red)
            }
            
            if let lastWeight = lastWeight {
                PointMark(
                    x: .value("Date", lastWeight.date),
                    y: .value("Weight", lastWeight.weight)
                )
                .symbolSize(50)
                .foregroundStyle(.green)
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartYScale(domain: Double(minWeight - 1)...Double(maxWeight + 1))
        .frame(height: 250)
        .padding()
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateSelectedWeight(at: value.location, proxy: proxy, geometry: geometry)
                            }
                    )
            }
        }
    }
    
    var selectedWeightInfo: some View {
        if let selectedWeight = selectedWeight {
            Text("Selected: \(selectedWeight.weight, specifier: "%.2f") kg on \(formattedDate(for: selectedWeight.date))")
                .padding()
        } else {
            Text("Tap on a point to see details")
                .padding()
        }
    }
    
    private func updateSelectedWeight(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotFrame!].origin.x
        guard let date: Date = proxy.value(atX: xPosition) else { return }
        
        let closestWeight = lastTenWeights.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) })
        selectedWeight = closestWeight
    }
    
    private func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
