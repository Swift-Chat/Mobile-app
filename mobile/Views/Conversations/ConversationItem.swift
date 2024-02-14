import SwiftUI
import model

struct ConversationItem: View {
    var conversation: Conversation

    var body: some View {
        VStack(alignment: .leading) {
            Text(conversation.user.username)
            if !conversation.messages.isEmpty {
                Text(conversation.messages.last?.content ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ConversationItem_Previews: PreviewProvider {
    static var previews: some View {
        ConversationItem(conversation: Conversation(
            messages: [],
            user: User(username: "Toto")
        ))
    }
}
