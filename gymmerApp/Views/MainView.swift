import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0 // Control the selected tab
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        VStack{
            
            if authViewModel.isLoggedIn {
                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Dashboard")
                        }
                        .tag(0)
                    
                    WeightListView()
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Weight")
                        }
                        .tag(1)
                    
                    AccountSettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(2)
                }
                .environmentObject(TabSelection(selectedTab: $selectedTab))
                .task {
                    authViewModel.checkSession() // Check if session is valid
                }
            } else {
                AuthView(isLoggedIn: $authViewModel.isLoggedIn)
            }
        }
    }
}

// Create an environment object to share tab selection across views
class TabSelection: ObservableObject {
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel()) // Inject AuthViewModel for Preview
}
