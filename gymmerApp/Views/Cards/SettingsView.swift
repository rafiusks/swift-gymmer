import SwiftUI

enum UnitSystem: String, CaseIterable, Identifiable {
    case metric = "Metric (kg, m)"
    case imperial = "Imperial (lbs, ft)"
    
    var id: String { self.rawValue }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the modal
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @AppStorage("selectedUnitSystem") private var storedUnitSystem: String = UnitSystem.metric.rawValue // Store the unit system in UserDefaults as a string
    @State private var profileImage: UIImage? = nil // State to hold the profile image
    @State private var fullName: String = "" // State to hold the user's full name
    @State private var dateOfBirth: Date = Date() // State to hold the user's date of birth
    @State private var age: Int? // State to hold the calculated age
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                NavigationLink(destination: EditProfileView()) {
                    
                    HStack(spacing: 12) {
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(fullName.isEmpty ? "Your Name" : fullName)
                                .font(.headline)
                                .foregroundColor(Color(UIColor.label))
                            
                            //                        if let age = age {
                            //                            Text("\(age) years old")
                            //                                .font(.footnote)
                            //                                .foregroundColor(Color(UIColor.secondaryLabel))
                            //                        }
                            
                            Text("youremail@example.com") // Replace with actual user email
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        
                    }
                    .padding(.vertical, 8)
                    .onAppear {
                        loadImageFromStorage()
                        loadFullNameFromStorage()
                        loadDateOfBirthFromStorage()
                    }
                    
                }
                
                Section(header: Text("")) {
                    
                    NavigationLink(destination: EditProfileView()) {
                        Text("Edit Profile")
                            .padding(.vertical, 8)
                    }
                    
                    NavigationLink(destination: Text("Change Goals")) {
                        Text("Change Goals")
                            .padding(.vertical, 8)
                    }
                    
                    NavigationLink(destination: Text("Units of Measurement")) {
                        HStack {
                            Text("Units of Measurement")
                        }
                        .padding(.vertical, 8)
                    }
                    
                }
                
                Section(header: Text("")) {
                    Button(action: {
                        Task {
                            await authViewModel.handleSignOut()
                        }
                    }) {
                        HStack {
                            Text("Log out")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                
            }
            .listStyle(.sidebar)
            .listRowBackground(Color(UIColor.systemGray5))
            .navigationBarTitle("Account", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss() // Dismiss the modal
            }
                .font(.headline) // Match font for "Done" button
                .foregroundColor(Color(UIColor.systemGreen)))
        }
        
    }
    
    // Load functions for image, full name, and date of birth
    private func loadImageFromStorage() {
        if let imagePath = UserDefaults.standard.string(forKey: "profileImagePath") {
            if let imageData = UIImage(contentsOfFile: imagePath) {
                profileImage = imageData
            }
        }
    }
    
    private func loadFullNameFromStorage() {
        if let savedFullName = UserDefaults.standard.string(forKey: "fullName") {
            fullName = savedFullName
        }
    }
    
    private func loadDateOfBirthFromStorage() {
        if let savedDateOfBirth = UserDefaults.standard.object(forKey: "dateOfBirth") as? Date {
            dateOfBirth = savedDateOfBirth
            age = calculateAge(from: savedDateOfBirth)
        }
    }
    
    private func calculateAge(from date: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        return ageComponents.year ?? 0
    }
}

#Preview {
    SettingsView()
    //        .preferredColorScheme(.dark)
        .environmentObject(AuthViewModel())
}
