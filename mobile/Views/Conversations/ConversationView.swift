import SwiftUI
import model

struct ConversationView: View {
    var conversation: Conversation
    @State var messageTextField: String = ""
    @EnvironmentObject var messageVM: MessagesViewModel

    var body: some View {
        VStack {
            MessageList(messages: conversation.messages)
            HStack {
                MessageTextField(message: $messageTextField)
                Button {
                    Task {
                        await messageVM.sendMessage(content: messageTextField, receiver: conversation.user)
                        messageTextField = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                }
                .foregroundColor(Color.purpleApp)
            }
            .padding(.bottom, 8)
        }
        .navigationTitle(conversation.user.username)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, 10)
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(
            conversation: Conversation(
                messages: [],
                user: User(username: "Toto")
            )
        )
    }
}
