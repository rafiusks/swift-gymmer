import SwiftUI

@main
struct gymmerAppApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView() // Start with SplashScreenView
                .environmentObject(AuthViewModel()) // Inject AuthViewModel for session handling
        }
    }
}
