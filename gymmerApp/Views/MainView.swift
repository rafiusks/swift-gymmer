//
//  ContentView.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 30/9/2024.
//

import SwiftUI
import Supabase

struct MainView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        VStack {
                    if authViewModel.isLoggedIn {
                        
//                        TopNav(authViewModel: authViewModel)
                        
                        // Show the TabView if logged in
                        TabView {
                            DashboardView()
                                .tabItem {
                                    Image(systemName: "person.crop.circle")
                                    Text("Dashboard")
                                }
                            WeightListView()
                                .tabItem {
                                    Image(systemName: "person.crop.circle")
                                    Text("Measurements")
                                }
                            ProfileView()
                                .tabItem {
                                    Image(systemName: "person.crop.circle")
                                    Text("Profile")
                                }
                        }
                    } else {
                        // Pass the binding for isLoggedIn to AuthView
                        AuthView(isLoggedIn: $authViewModel.isLoggedIn)
                    }
                }
                .onAppear {
                    authViewModel.checkSession()
                }
    }
}

#Preview {
    MainView()
}
