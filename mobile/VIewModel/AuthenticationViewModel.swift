import Foundation
import model
import SwiftUI

enum AuthenticationState {
    case loggedOut(errorMessage: String?)
    case loggedIn(token: Token)
}

class AuthenticationViewModel: ObservableObject {
    @Published var authState: AuthenticationState = .loggedOut(errorMessage: nil)
    @Published var presenteErrorMessage: Bool = false

    public var errorMessage: String? {
        switch authState {
        case .loggedOut(let errorMessage):
            return errorMessage
        case .loggedIn:
            return nil
        }
    }

    public var token: Token? {
        switch authState {
        case .loggedOut:
            return nil
        case .loggedIn(let token):
            return token
        }
    }

    func handleLoginResult(result: Result<Token, Error>) {
        switch result {
        case .success(let tokenValue):
            authState = .loggedIn(token: tokenValue)
        case .failure(let error):
            authState = .loggedOut(errorMessage: error.localizedDescription)
            presenteErrorMessage = true
        }
    }

    func logout() {
        // TODO: Close websocket
        authState = .loggedOut(errorMessage: nil)
    }
}
