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
                Text("Gymmer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Don't forget to stretch")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 50) // Increase the spacing between groups
            
            // Group 2: Email and Password input fields + Forgot Password
            VStack(spacing: 20) {
                CustomTextField(
                    icon: "envelope",
                    placeholder: "Email",
                    text: $email,
                    isLowercase: true
                )
                
                CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                
                //TODO: Forgot password link and functionality
                
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50) // Add space between input fields and the button
            
            // Group 3: Sign in button
            Button(action: {
                signInButtonTapped()
            }) {
                VStack(alignment: .center) {
                    Text("Currently in development, \n no sign in available.")
                        .foregroundStyle(Color(UIColor.systemRed))
                        .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Login")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    AppColors.gradientStart,
                                    AppColors.gradientEnd
                                ]
                            ),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(25)
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // Apply a plain background to ensure no gradient
        .ignoresSafeArea()
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
