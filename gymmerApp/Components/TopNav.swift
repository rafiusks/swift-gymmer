//
//  TopNav.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 1/10/2024.
//

import SwiftUI
import Supabase

struct TopNav: View {
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        Button("Logout") {
                                    Task {
                                        await authViewModel.handleSignOut()
                                    }
        }
    }
}
