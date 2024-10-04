import SwiftUI

struct DashboardView: View {
    @State private var fullName: String = "" // State to hold the user's full name
    @State private var profileImage: UIImage? = nil // State to hold the profile image
    @EnvironmentObject var tabSelection: TabSelection // Assuming you use an environment object to control the tab selection
    
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
                
                // Make profile image tappable, navigating to the Settings tab
                Button(action: {
                    tabSelection.selectedTab = 2 // Change the selected tab to "Settings"
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
                }
            }
            .padding(.bottom, 20)
            
            Spacer()
            
            // Widgets
            WeightTrackingWidget()
            
            Spacer()
            
            //TODO: More widgets, selection and sorter
            
            Spacer()
        }
        .padding()
        .onAppear {
            loadImageFromStorage() // Load the profile image when the view appears
            loadFullNameFromStorage()
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
