import Foundation
import model

extension Message: Identifiable {}

extension Conversation: Identifiable {
    public var id: String {
        return user.username
    }
}
