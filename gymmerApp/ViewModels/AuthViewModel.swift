import Supabase
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        checkSession() // Automatically check session on init
    }

    func checkSession() {
        Task {
            do {
                let session = try await supabase.auth.session
                DispatchQueue.main.async {
                    // Check if the session is valid and update state
                    self.isLoggedIn = !session.accessToken.isEmpty
                }
            } catch {
                DispatchQueue.main.async {
                    // If no session is found or an error occurs, set to logged out
                    self.isLoggedIn = false
                }
            }
        }
    }

    func handleSignOut() async {
        do {
            try await supabase.auth.signOut()
            DispatchQueue.main.async {
                // After signing out, set isLoggedIn to false
                self.isLoggedIn = false
            }
        } catch {
            print("Failed to sign out: \(error)")
        }
    }
}
