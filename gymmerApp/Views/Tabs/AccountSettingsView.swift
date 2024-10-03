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

    @AppStorage("darkModeSetting") private var darkModeSetting: DarkModeSetting = .system // Store the selected dark mode option
    @State private var selectedUnitSystem: UnitSystem = .metric

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
}

// Reusable component for settings rows
struct SettingsRowView: View {
    var icon: String
    var text: String

    var body: some View {
        HStack {
            Label(text, systemImage: icon)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    AccountSettingsView()
}
