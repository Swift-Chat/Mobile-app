import SwiftUI
import model

struct ContentView: View {
    @StateObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var messageViewModel: MessagesViewModel

    init(authenticationVM: AuthenticationViewModel) {
        _authenticationViewModel = StateObject(wrappedValue: authenticationVM)
        _messageViewModel = StateObject(wrappedValue: MessagesViewModel(authenticationVM: authenticationVM))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                Header()
                List {
                    ForEach(messageViewModel.conversations) { conversation in
                        NavigationLink {
                            ConversationView(conversation: conversation)
                        } label: {
                            ConversationItem(conversation: conversation)
                        }
                    }
                }
                .background(Color.backgroundPurple)
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
            .navigationTitle("Conversations")
        }
        .navigationViewStyle(.stack)
        .environmentObject(messageViewModel)
        .environmentObject(authenticationViewModel)
        .task {
            guard let token = authenticationViewModel.token else {
                authenticationViewModel.logout()
                return
            }

            await messageViewModel.getConversations(token: token)

            await messageViewModel.connectToWebsocket(token: token)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(authenticationVM: AuthenticationViewModel())
    }
}
