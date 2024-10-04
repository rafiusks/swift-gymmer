import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoSize: CGFloat = 0.7
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        AppColors.gradientStart,
                        AppColors.gradientEnd
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()
            
            if isActive {
                // Transition to the MainView
                MainView()
            } else {
                VStack {
                    Spacer()
                    
                    Text("GYMMER") // App name
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(Color.white)
                        .shadow(radius: 10) // Adds a subtle shadow for more depth
                    
                    Spacer()
                    
                    // Optional subtext for extra touch
                    Text("Beta version: 0.1.0 - We are just warming up")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.7))
                        .italic()
                        .padding(.bottom, 40)
                    
                    
                    // Loading indicator (optional, for visual polish)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding(.bottom, 60) // Adjust bottom padding
                        .opacity(opacity)
                }
                .onAppear {
                    // Animation effect when the splash screen appears
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.logoSize = 1.0
                        self.opacity = 1.0
                    }
                    
                    // Transition to the main view after delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(AuthViewModel()) // Inject environment object for preview
}
