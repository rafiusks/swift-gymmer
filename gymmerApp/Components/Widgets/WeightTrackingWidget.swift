import SwiftUI

struct WeightTrackingWidget: View {
    // Sample data for weight tracking
    var currentWeight: Double = 78.5 // Current weight in kg
    var targetWeight: Double = 72.0 // Target weight in kg
    
    @EnvironmentObject var tabSelection: TabSelection // Access the tab selection environment object
    
    // Progress as a percentage of the target
    var progress: Double {
        max(0, min(1, (currentWeight - targetWeight) / currentWeight))
    }
    
    var body: some View {
        ZStack {
            // Background chart with a larger height, but clipped to hide overflow
            WeightChartView()
                .frame(maxWidth: .infinity, minHeight: 300) // Larger height than the widget frame
                .opacity(0.4) // Make the chart background semi-transparent
                .offset(y: 40) // Offset to push the chart slightly up
                .clipped() // Clipping any overflow outside the frame
            
            // Overlay content with text and progress circle
            HStack {
                // Text Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weight Progress")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Current: \(currentWeight, specifier: "%.1f") \(WeightUnit().unit)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Target: \(targetWeight, specifier: "%.1f") \(WeightUnit().unit)")
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
                        .stroke(AngularGradient(gradient: Gradient(colors: [Color.orange, Color.red]), center: .center), lineWidth: 8)
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
        }
        .frame(height: 100) // Constrain the overall widget height
        .clipped() // Clip any overflow content from the ZStack
        .background(Color.black.opacity(1)) // Optional overlay for better readability
        .cornerRadius(20) // Rounded corners
        .shadow(radius: 5) // Shadow effect
        .onTapGesture {
            tabSelection.selectedTab = 1 // Change to the weight tab
        }
    }
}

#Preview {
    WeightTrackingWidget()
        .environmentObject(TabSelection(selectedTab: .constant(1)))
}
