import SwiftUI

struct CustomTextField: View {
    
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool?
    var isLowercase: Bool?
    var useSpacer: Bool?
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            
            // Use spacer to push content apart
            if useSpacer ?? false {
                Spacer()
                Text(placeholder).foregroundColor(.gray)
            }
            
            if isSecure == true {
                SecureField(placeholder, text: $text)
            } else {
                
                // Conditional for secure and non-secure fields
                if isLowercase == true {
                    TextField(placeholder, text: $text)
                        .multilineTextAlignment(useSpacer ?? false ? .trailing : .leading)
                        .onChange(of: text) { oldValue, newValue in
                            if newValue != newValue.lowercased() {
                                text = newValue.lowercased()
                            }
                        }
                } else {
                    TextField(placeholder, text: $text)
                        .multilineTextAlignment(useSpacer ?? false ? .trailing : .leading)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomTextField(
            icon: "envelope",
            placeholder: "Email",
            text: .constant(""),
            isLowercase: true,
            useSpacer: true
        ) // Spacer included
        CustomTextField(
            icon: "lock",
            placeholder: "Password",
            text: .constant(""),
            isSecure: true
        )  // Without spacer
    }
    .padding()
}
