import SwiftUI
import Supabase

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var result: Result<Void, Error>?
    
    // Add a binding to update isLoggedIn
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            // Group 1: Welcome Text
            VStack(spacing: 8) {
                Text("Hey there,")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 50) // Increase the spacing between groups
            
            // Group 2: Email and Password input fields + Forgot Password
            VStack(spacing: 20) {
                CustomTextField(icon: "envelope", placeholder: "Email", text: $email, isSecure: false)
                CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                
                // Forgot password link
                HStack {
                    Spacer()
                    Button(action: {
                        // Forgot password logic
                    }) {
                        Text("Forgot your password?")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50) // Add space between input fields and the button
            
            // Group 3: Sign in button
            Button(action: {
                signInButtonTapped()
            }) {
                if isLoading {
                    ProgressView() // Show a progress indicator when loading
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Login")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(25)
                    .shadow(radius: 5)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 24)

            // Display error or success message
            if let result = result {
                VStack {
                    switch result {
                    case .success:
                        Text("Login Successful")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                    case .failure(let error):
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 10)
            }
        }
        .onOpenURL { url in
            Task {
                do {
                    try await supabase.auth.session(from: url)
                } catch {
                    self.result = .failure(error)
                }
            }
        }
    }

    func signInButtonTapped() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                try await supabase.auth.signIn(email: email, password: password)
                result = .success(())
                
                DispatchQueue.main.async {
                    isLoggedIn = true
                }
            } catch {
                result = .failure(error)
            }
        }
    }
}

// Custom text field with icon
struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }
}

#Preview {
    AuthView(isLoggedIn: .constant(false))
}
