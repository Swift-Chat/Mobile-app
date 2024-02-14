import SwiftUI

struct MessageTextField: View {
    @Binding var message: String
    var body: some View {
        TextField("Your message", text: $message)
            .padding(10)
            .frame(height: 50)
            .background(Color.gray230)
            .cornerRadius(50)
    }
}

struct MessageTextField_Previews: PreviewProvider {
    static var previews: some View {
        MessageTextField(
            message: .constant("")
        )
    }
}
