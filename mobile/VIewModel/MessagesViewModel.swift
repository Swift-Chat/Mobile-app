import Foundation
import model

class MessagesViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    var authenticationVM: AuthenticationViewModel

    var messageService: MessageService

    init (authenticationVM: AuthenticationViewModel) {
        self.authenticationVM = authenticationVM
        self.messageService = MessageService()
    }

    func getConversations(token: Token) async {
        await messageService.getConversations(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let conversations):
                    self.conversations = conversations
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }

    func connectToWebsocket(token: Token) async {
        await messageService.connect(token: token, messageHandler: addMessage(message:))
    }

    func sendMessage(content: String, receiver: User) async {
        guard let connectedUser = self.authenticationVM.token?.user else {
            self.authenticationVM.logout()
            return
        }

        self.messageService.sendMessage(messageInput: MessageInput(
            content: content,
            sender: connectedUser,
            receiver: receiver
        ))
    }

    private func addMessage(message: Message) {
        guard let connectedUser = self.authenticationVM.token?.user else {
            self.authenticationVM.logout()
            return
        }

        let user = message.sender == connectedUser ? message.receiver : message.sender

        guard let convIndex = self.conversations.firstIndex(where: { conversation in
            conversation.user.username == user.username
        }) else {
            self.conversations.append(Conversation(messages: [message], user: user))
            return
        }

        conversations[convIndex].messages.append(message)
        self.objectWillChange.send()
    }
}
