import SwiftUI
import model

struct MessageList: View {
    var messages: [Message]

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ScrollViewReader { value in
                    VStack {
                        ForEach(messages) { message in
                            MessageItem(message: message, padding: geometry.size.width * 0.4)
                        }
                        Spacer()
                            .frame(height: 10)
                            .id("LastSpacer")
                    }
                    .onChange(of: messages) { _ in
                        withAnimation(.easeInOut) {
                            value.scrollTo("LastSpacer")
                        }
                    }
                }
            }
        }
    }
}

struct MessageList_Previews: PreviewProvider {
    static var previews: some View {
        MessageList(
            messages: []
        )
    }
}
