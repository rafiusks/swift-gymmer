import SwiftUI

struct WeightTrackingWidget: View {
    
    @EnvironmentObject var weightViewModel: WeightViewModel
    @EnvironmentObject var tabSelection: TabSelection
    
    @State private var currentWeight: Double? = nil
    var targetWeight: Double? = 72
    
    var progress: Double {
        if currentWeight == nil { return 0 }
        if targetWeight == nil { return 0 }
        
        guard let currentWeight = currentWeight, let targetWeight = targetWeight else { return 0 }
        
        // If aiming to lose weight (current weight is higher than target)
        if currentWeight > targetWeight {
            return max(0, min(1, (targetWeight / currentWeight)))
        }
        // If aiming to gain weight (current weight is lower than target)
        else if currentWeight < targetWeight {
            return max(0, min(1, (currentWeight / targetWeight)))
        }
        
        // If weights are equal (goal reached)
        return 1.0
    }
    
    var body: some View {
        ZStack {
            
            WeightChartView()
                .frame(maxWidth: .infinity, minHeight: 170)
                .opacity(0.3) // Lighter opacity for dark mode
                .offset(y: 55)
                .clipped()
            
            VStack {
                
                VStack{
                    
                    HStack {
                        Text("Weight Progress")
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
                    
                    //horizontal line
                    Divider()
                        .background(Color.white) // Set the color of the line
                        .padding(.bottom, 20)
                }
                
                HStack {
                    
                    ZStack {
                        // Check if target weight is set
                        if (targetWeight != nil) {
                            // Circular progress background
                            Circle()
                                .stroke(lineWidth: 15)
                                .opacity(0.3)
                                .foregroundColor(.gray)
                            
                            // Circular progress foreground
                            Circle()
                                .trim(from: 0.0, to: progress)
                                .stroke(
                                    Gradient(
                                        colors: [
                                            Color(UIColor.systemRed),
                                            Color(UIColor.systemPink)
                                        ]
                                    ),
                                    
                                    lineWidth: 20
                                ) // Solid color for dark mode
                                .rotationEffect(Angle(degrees: 270)) // Start at the top
                                .animation(.easeInOut, value: progress) // Smooth animation
                            
                            // Progress percentage text
                            Text("\(Int(progress * 100))%")
                                .font(.headline)
                                .foregroundColor(.white)
                        } else {
                            // No target weight set, show a call to action
                            VStack(spacing: 8) {
                                
                                Button(action: {
                                    // Action to navigate to goal setting view or modal
                                    tabSelection.selectedTab = 2 // Navigate to the settings tab for goal setting
                                }) {
                                    Text("Set Goal")
                                        .font(.subheadline)
                                        .foregroundColor(.black) // Dark text for button
                                        .padding()
                                        .background(Color.white) // White button for contrast
                                        .cornerRadius(10)
                                }
                            }
                            .frame(width: 150, height: 150) // Custom frame size for CTA
                            .background(Color.black.opacity(0.8)) // Make the CTA stand out with darker background color
                            .cornerRadius(20) // Rounded edges for the CTA box
                            .shadow(radius: 5)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .padding(.trailing, 50)
                    
                    Spacer()
                    
                    // Text Section
                    VStack(alignment: .leading, spacing: 8) {
                        
                        if let currentWeight = currentWeight {
                            
                            VStack {
                                Text("Current")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("\(currentWeight, specifier: "%.1f")\(WeightUnit().unit)")
                                    .font(.title2)
                                    .foregroundColor(Color(UIColor.systemGreen))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            
                        } else {
                            Text("Loading...")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        
                        if targetWeight != nil {
                            
                            VStack {
                                Text("Goal")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("\(targetWeight ?? 0.0, specifier: "%.1f")\(WeightUnit().unit)")
                                    .font(.title2)
                                    .foregroundColor(Color(UIColor.systemGreen))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            
                        } else {
                            Text("Target not set")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
                
                
                Spacer()
            }
            .frame(height: 190)
            
        }
        .frame(height: 200, alignment: .top) // Constrain the overall widget height
        //        .clipped() // Clip any overflow content from the ZStack
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10) // Rounded corners
        .onTapGesture {
            tabSelection.selectedTab = 1 // Change to the weight tab
        }
        .onAppear {
            Task {
                if let latestWeight = await weightViewModel.fetchLatestWeight() {
                    currentWeight = Double(
                        latestWeight.weight
                    ) // Update the current weight
                }
            }
        }
    }
}

#Preview {
    WeightTrackingWidget().preferredColorScheme(.dark)
        .environmentObject(WeightViewModel()) // Provide the weight view model
        .environmentObject(TabSelection(selectedTab: .constant(1)))
    
}
