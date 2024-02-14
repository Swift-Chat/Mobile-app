import SwiftUI

struct MessageCapsule: View {
    let message: String
    let textColor: Color
    let senderMessage: Bool

    var body: some View {
        Text(message)
            .font(.headline.weight(.medium))
            .foregroundColor(senderMessage ? .white : Color.gray95)
            .padding()
            .background(
                RoundedCorner(
                    radius: 20,
                    corners: [
                        senderMessage ? .bottomLeft : .bottomRight,
                        .topLeft,
                        .topRight
                    ]
                )
                    .fill(
                        senderMessage ? Color.purpleApp : Color.gray230
                    )
            )
    }
}

struct MessageCapsule_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageCapsule(
                message: "Test",
                textColor: .white,
                senderMessage: true
            )

            MessageCapsule(
                message: "Test",
                textColor: .white,
                senderMessage: false
            )
        }
    }
}
