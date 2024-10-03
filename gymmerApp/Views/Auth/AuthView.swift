import SwiftUI

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
            .padding(.horizontal, 32)
            .padding(.top, 24)
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

#Preview {
    AuthView(isLoggedIn: .constant(false))
}
