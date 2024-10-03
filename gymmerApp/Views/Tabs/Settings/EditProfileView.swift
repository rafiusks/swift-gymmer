import SwiftUI

struct EditProfileView: View {
    @State private var fullName: String = "Andrei Kozlov"
    @State private var dateOfBirth: Date = Date() // You can change the initial value
    @State private var phoneNumber: String = "+7652562352"
    @State private var email: String = "Alexanold@mail.com"
    @State private var password: String = "********"
    
    var body: some View {
        VStack {
            // Top bar with back button and title
//            HStack {
//                Button(action: {
//                    // Handle back action here
//                }) {
//                    Image(systemName: "arrow.backward")
//                        .foregroundColor(.black)
//                }
//
//                Spacer()
//
//                Text("Details Account")
//                    .font(.title2)
//                    .fontWeight(.bold)
//            }
            
            // Profile Image and Edit Button
            VStack(spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "person.circle.fill") // Placeholder image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())

                    // Edit Profile Image button
                    Button(action: {
                        // Handle edit image action here (e.g., open image picker)
                    }) {
                        Image(systemName: "pencil")
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
            }
            .padding(.vertical, 20)

            // Form fields for profile details, replacing Form with VStack
            ScrollView {
                VStack(spacing: 20) {
                    // Full Name
                    CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $fullName, isSecure: false, useSpacer: true)
                        .frame(maxWidth: .infinity) // Full width
                        .frame(height: 50) // Set consistent height
                    
                    // Date of Birth (Calendar Only)
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                            .labelsHidden()
                    }
                    .padding(.horizontal) // Add left padding inside HStack
                    .frame(maxWidth: .infinity)
                    .frame(height: 50) // Set same height
                    .background(Color(UIColor.systemGray6)) // Background color
                    .cornerRadius(10) // Rounded corners
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                .padding(.top, 16)
            }
            .frame(height: 400) // Adjust scrollable height as needed
            .padding(.bottom, 16) // Add padding at the bottom for spacing
            
            Spacer() // Pushes the button to the bottom

            // Update Profile Button
            Button(action: {
                // Handle change profile action here
            }) {
                Text("Update Profile")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(25)
            }
            .padding(.bottom, 20) // Bottom padding for the button
        }
        .padding(20)
        .navigationTitle("Edit Profile")  // Set the title
        .navigationBarTitleDisplayMode(.inline)
    }
    

    // Helper function to format date
    func formattedDate(of date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

// Assuming you have a CustomTextField elsewhere in your project
#Preview {
    NavigationView {
            EditProfileView()
        }
}
