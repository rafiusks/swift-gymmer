//
//  gymmerAppApp.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 30/9/2024.
//

import SwiftUI

@main
struct gymmerAppApp: App {
    var body: some Scene {
        WindowGroup {
                    MainView() // The root view
                        .environmentObject(AuthViewModel()) // Inject the shared AuthViewModel
                }
    }
}
