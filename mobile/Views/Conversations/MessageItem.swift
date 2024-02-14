import SwiftUI
import model

struct MessageItem: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    var user: User? {
        guard let user = authenticationViewModel.token?.user else {
            authenticationViewModel.logout()
            return nil
        }

        return user
    }

    let message: Message
    let padding: Double
    var isSender: Bool {
        message.sender == user
    }

    var body: some View {
        HStack {
            if isSender {
                Spacer(minLength: padding)
                MessageCapsule(
                    message: message.content,
                    textColor: .white,
                    senderMessage: isSender
                )
            } else {
                MessageCapsule(
                    message: message.content,
                    textColor: .white,
                    senderMessage: isSender
                )
                Spacer(minLength: padding)
            }
        }
    }
}

struct MessageItem_Previews: PreviewProvider {
    static var previews: some View {
        MessageItem(
            message: Message(
                id: 1,
                content: "", sender: User(username: ""),
                receiver: User(username: "")
            ),
            padding: 10
        )
    }
}
