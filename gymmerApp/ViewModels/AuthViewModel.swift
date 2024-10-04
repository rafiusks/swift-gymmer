import Supabase
import SwiftUI

@MainActor
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
                    self.isLoggedIn = !session.accessToken.isEmpty
                }
            } catch let error as NSError {
                if error.code == errSecItemNotFound {
                    // This is not an error, just means there's no session
                    DispatchQueue.main.async {
                        self.isLoggedIn = false
                    }
                } else {
                    // Handle other errors
                    print("Error retrieving session: \(error.localizedDescription)")
                    await self.handleSignOut()
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
