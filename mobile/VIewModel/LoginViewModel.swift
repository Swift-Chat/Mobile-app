import Foundation
import model

class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()

    let authService: AuthenticationService = AuthenticationService()

    var loginDisabled: Bool {
        credentials.username.isEmpty || credentials.password.isEmpty
    }

    func login(completion: @escaping (Result<Token, Error>) -> Void) {
        authService.login(credentials: credentials, completion: completion)
    }
}
