import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @State private var fullName: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    @State private var showImageSourceOptions: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showConfirmationAlert = false // State to show the confirmation alert
    
    var body: some View {
        VStack {
            // Profile Image and Edit Button
            VStack(spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    // Edit Profile Image button
                    Button(action: {
                        showImageSourceOptions = true // Show options for camera or photo library
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
            
            // Form fields for profile details
            ScrollView {
                VStack(spacing: 20) {
                    // Full Name
                    CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $fullName, useSpacer: true)
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
                // Save profile image and name
                if let profileImage = profileImage {
                    saveImageLocally(image: profileImage)
                }
                saveFullName() // Save the full name
                // Show confirmation alert after updating
                showConfirmationAlert = true
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
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Profile Updated"),
                    message: Text("Your profile has been successfully updated."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding(20)
        .navigationTitle("Edit Profile")  // Set the title
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $profileImage, sourceType: sourceType)
        }
        .actionSheet(isPresented: $showImageSourceOptions) {
            ActionSheet(
                title: Text("Select Image Source"),
                message: Text("Choose an option to change your profile image."),
                buttons: [
                    .default(Text("Camera")) {
                        sourceType = .camera
                        isImagePickerPresented = true
                    },
                    .default(Text("Photo Library")) {
                        sourceType = .photoLibrary
                        isImagePickerPresented = true
                    },
                    .cancel()
                ]
            )
        }
        .onAppear {
            loadImageFromStorage() // Load saved profile image
            loadFullNameFromStorage() // Load saved full name
        }
    }
    
    // Save image to local storage
    func saveImageLocally(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectory.appendingPathComponent("profileImage.jpg")
            
            do {
                try imageData.write(to: fileURL)
                // Save the file path to UserDefaults
                UserDefaults.standard.set(fileURL.path, forKey: "profileImagePath")
                print("Image saved at \(fileURL.path)")
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
    
    // Load image from local storage
    func loadImageFromStorage() {
        if let imagePath = UserDefaults.standard.string(forKey: "profileImagePath") {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: imagePath) {
                if let imageData = UIImage(contentsOfFile: imagePath) {
                    profileImage = imageData
                }
            }
        }
    }
    
    // Save full name to UserDefaults
    func saveFullName() {
        UserDefaults.standard.set(fullName, forKey: "fullName")
    }
    
    // Load full name from UserDefaults
    func loadFullNameFromStorage() {
        if let savedFullName = UserDefaults.standard.string(forKey: "fullName") {
            fullName = savedFullName
        }
    }
}

#Preview {
    NavigationView {
        EditProfileView()
    }
}
