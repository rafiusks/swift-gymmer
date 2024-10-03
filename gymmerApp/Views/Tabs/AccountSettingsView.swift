import SwiftUI

enum UnitSystem: String, CaseIterable, Identifiable {
    case metric = "Metric (kg, m)"
    case imperial = "Imperial (lbs, ft)"
    
    var id: String { self.rawValue }
}

enum DarkModeSetting: String, CaseIterable, Identifiable {
    case on = "On"
    case off = "Off"
    case system = "Auto"
    
    var id: String { self.rawValue }
}

struct AccountSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @AppStorage("darkModeSetting") private var darkModeSetting: DarkModeSetting = .system
    @State private var selectedUnitSystem: UnitSystem = .metric
    @State private var profileImage: UIImage? = nil // State to hold the profile image
    @State private var fullName: String = "" // State to hold the user's full name
    @State private var dateOfBirth: Date = Date() // State to hold the user's date of birth
    @State private var age: Int? // State to hold the calculated age
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Top bar with title and logout button
                HStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await authViewModel.handleSignOut()
                        }
                    }) {
                        HStack {
                            Text("Log out")
                                .foregroundColor(.red)
                            Image(systemName: "arrowshape.turn.up.right")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Profile section
                HStack(spacing: 8) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading) {
                        // Display the loaded full name from UserDefaults
                        Text(fullName.isEmpty ? "Your Name" : fullName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        // Display the user's age if available
                        if let age = age {
                            Text("\(age) years old")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        } else {
                            Text("Unknown age")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    loadImageFromStorage() // Load the profile image on appear
                    loadFullNameFromStorage() // Load the full name on appear
                    loadDateOfBirthFromStorage() // Load the date of birth and calculate age
                }
                
                // Settings list
                List {
                    NavigationLink(destination: EditProfileView()) {
                        SettingsRowView(icon: "person.fill", text: "Edit Profile")
                            .frame(height: 50)
                    }
                    
                    SettingsRowView(icon: "star.fill", text: "Set my goal")
                        .frame(height: 50)
                }
                .listStyle(.plain)
                
                Text("App Settings")
                List {
                    // Dark Mode Picker
                    HStack {
                        Label("", systemImage: "moon.fill")
                        Spacer()
                        Picker("", selection: $darkModeSetting) {
                            ForEach(DarkModeSetting.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Use segmented style for the options
                    }
                    .frame(height: 50)
                    
                    // Unit system picker
                    HStack {
                        Label("", systemImage: "ruler")
                        Spacer()
                        Picker("", selection: $selectedUnitSystem) {
                            ForEach(UnitSystem.allCases) { system in
                                Text(system.rawValue).tag(system)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .frame(height: 50)
                }
                .listStyle(.plain)
            }
            .padding(.top, 40)
            .preferredColorScheme(determineColorScheme()) // Apply the color scheme dynamically
        }
    }
    
    // Function to determine which color scheme to apply
    private func determineColorScheme() -> ColorScheme? {
        switch darkModeSetting {
            case .on:
                return .dark
            case .off:
                return .light
            case .system:
                return nil // Use system's default setting
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
    
    // Function to load the full name from UserDefaults
    private func loadFullNameFromStorage() {
        if let savedFullName = UserDefaults.standard.string(forKey: "fullName") {
            fullName = savedFullName
        }
    }
    
    // Function to load the date of birth and calculate age
    private func loadDateOfBirthFromStorage() {
        if let savedDateOfBirth = UserDefaults.standard.object(forKey: "dateOfBirth") as? Date {
            dateOfBirth = savedDateOfBirth
            age = calculateAge(from: savedDateOfBirth) // Calculate the age based on the saved date of birth
        }
    }
    
    // Helper function to calculate age based on the date of birth
    private func calculateAge(from date: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        return ageComponents.year ?? 0
    }
}

// Reusable component for settings rows
struct SettingsRowView: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Label(text, systemImage: icon)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    AccountSettingsView()
}
