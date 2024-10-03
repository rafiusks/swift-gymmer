import SwiftUI

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
                    .onChange(of: text) { oldValue, newValue in
                        if newValue != newValue.lowercased() {
                            text = newValue.lowercased()
                        }
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
    CustomTextField(icon: "envelope", placeholder: "Email", text: .constant(""), isSecure: false)
}
