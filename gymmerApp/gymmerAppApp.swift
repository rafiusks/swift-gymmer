import SwiftUI

@main
struct gymmerAppApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView() // Start with SplashScreenView
                .preferredColorScheme(.dark)
                .environmentObject(WeightViewModel())
                .environmentObject(AuthViewModel()) // Inject AuthViewModel for session handling
        }
    }
}
