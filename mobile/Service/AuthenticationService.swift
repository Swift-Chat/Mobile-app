import Foundation
import model

struct ApiError: Codable, LocalizedError {
    var reason: String

    public init(reason: String) {
        self.reason = reason
    }

    public var errorDescription: String? {
        return reason
    }
}

class AuthenticationService {
    private var loginEndPoint = URL(string: "http://127.0.0.1:8080/login")
    private var logoutEndPoint = URL(string: "http://127.0.0.1:8080/logout")

    func login(credentials: Credentials, completion: @escaping (Result<Token, Error>) -> Void) {
        if credentials.username.isEmpty || credentials.password.isEmpty {
            completion(.failure(ApiError(reason: "Username or Password not provided")))
        } else {
            guard let loginEndPoint = loginEndPoint else {
                completion(.failure(ApiError(reason: "Could not reach login endpoint")))
                return
            }

            var request = URLRequest(url: loginEndPoint)

            request.httpMethod = "POST"

            guard let authData = "\(credentials.username):\(credentials.password)"
                .data(using: .utf8)?
                .base64EncodedString()
            else {
                completion(.failure(ApiError(reason: "Could not create auth data")))
                return
            }
            request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        guard let data = data else {
                            completion(.failure(ApiError(reason: "An error has occured")))
                            return
                        }

                        do {
                            let token = try JSONDecoder().decode(Token.self, from: data)
                            completion(.success(token))
                        } catch {
                            do {
                                let apiError = try JSONDecoder().decode(ApiError.self, from: data)
                                completion(.failure(apiError))
                            } catch {
                                completion(.failure(ApiError(reason: "An error has occured")))
                            }
                        }
                    }
                }
            }.resume()
        }
    }
}
