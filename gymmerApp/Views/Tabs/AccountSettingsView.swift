import SwiftUI

struct AccountSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel // Use EnvironmentObject

    @State private var isDarkMode = false

    var body: some View {
        VStack(spacing: 20) {
            // Top bar with title and logout button
            HStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    Task {
                        await authViewModel.handleSignOut() // Use the shared AuthViewModel instance
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
            VStack(spacing: 8) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())

                Text("Andrei Kozlov")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Join since 2020")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()

            // Metrics section
            HStack(spacing: 20) {
                VStack {
                    Text("10 h 52 m")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Time Spending")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)

                VStack {
                    Text("96,54%")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Wellness statistics")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
            }
            .padding(.horizontal)

            // Settings list
            List {
//                SettingsRowView(icon: "person.fill", text: "Edit Profile")
//                SettingsRowView(icon: "star.fill", text: "Set my goal")
//                SettingsRowView(icon: "person.2.fill", text: "Invite Friends")

                // Dark Mode Toggle
                HStack {
                    Label("Dark Mode", systemImage: "moon.fill")
                    Spacer()
                    Toggle(isOn: $isDarkMode) {
                        // Empty closure
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .padding(.top, 40) // Adjust top padding as needed
    }
}

#Preview {
    AccountSettingsView()
}
