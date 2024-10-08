import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var tabSelection: TabSelection
    
    @State private var fullName: String = "" // State to hold the user's full name
    @State private var profileImage: UIImage? = nil // State to hold the profile image
    @State private var isShowingModal = false
    
    // Function to determine the part of the day (morning, afternoon, evening)
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            case 0..<12:
                return "Good morning"
            case 12..<18:
                return "Good afternoon"
            default:
                return "Good evening"
        }
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                // Profile Image and Greeting Section
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(getGreeting()), \(fullName)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7) // Ensure long names fit
                        Text("Welcome back")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingModal = true // Change the selected tab to "Settings"
                    }) {
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                    }.sheet(isPresented: $isShowingModal) {
                        SettingsView().preferredColorScheme(.dark)
                    }
                    
                    
                }
                .padding(.bottom, 20)
                
                // Widgets
                WeightTrackingWidget()
                
                TodaysWorkoutWidget()
                
                Spacer()
            }
            .padding()
            .onAppear {
                loadImageFromStorage() // Load the profile image when the view appears
                loadFullNameFromStorage()
            }
        }
    }
    
    // Function to load the profile image from local storage
    private func loadImageFromStorage() {
        if let imagePath = UserDefaults.standard.string(forKey: "profileImagePath") {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: imagePath) {
                if let imageData = UIImage(contentsOfFile: imagePath) {
                    profileImage = imageData
                }
            }
        }
    }
    
    private func loadFullNameFromStorage() {
        if let savedFullName = UserDefaults.standard.string(forKey: "fullName") {
            fullName = savedFullName
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(TabSelection(selectedTab: .constant(2))) // Provide the environment object for preview
}
