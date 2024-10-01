//
//  AuthViewModel.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 1/10/2024.
//

import Supabase
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        checkSession()
    }

    func checkSession() {
        Task {
            do {
                let session = try await supabase.auth.session
                DispatchQueue.main.async {
                    self.isLoggedIn = !session.accessToken.isEmpty
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                }
            }
        }
    }

    func handleSignOut() async {
        do {
            try await supabase.auth.signOut()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        } catch {
            print("Failed to sign out: \(error)")
        }
    }
}
