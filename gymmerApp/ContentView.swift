//
//  ContentView.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 30/9/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            AuthView()

//            TabView {
//                DashboardView()
//                .tabItem {
//                        Image(systemName: "person.crop.circle")
//                        Text("Dashboard")
//                    }
//                MeasurementsView()
//                .tabItem {
//                        Image(systemName: "person.crop.circle")
//                        Text("Measurements")
//                    }
//                ProfileView()
//                .tabItem {
//                    Image(systemName: "person.crop.circle")
//                    Text("Profile")
//                }
//            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
