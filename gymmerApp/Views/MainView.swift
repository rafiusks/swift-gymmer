import SwiftUI
import Supabase

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel // Use EnvironmentObject for AuthViewModel

    var body: some View {
        VStack {
            if authViewModel.isLoggedIn {
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
                    AccountSettingsView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                }
            } else {
                // Show AuthView if not logged in
                AuthView(isLoggedIn: $authViewModel.isLoggedIn)
            }
        }
        .onAppear {
            authViewModel.checkSession() // Check session when the view appears
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel()) // Inject AuthViewModel for Preview
}
