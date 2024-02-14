import Foundation
import model

class MessageService {
    private var socketEndPoint = URL(string: "ws://127.0.0.1:8080/swift_chat")

    private var webSocketTask: URLSessionWebSocketTask?

    func getConversations(token: Token, completion: @escaping (Result<[Conversation], Error>) -> Void) async {
        guard let endpoint = URL(string: "http://127.0.0.1:8080/conversations") else {
            return
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token.value)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(ApiError(reason: "No data found")))
                return
            }

            do {
                let conversations = try JSONDecoder().decode([Conversation].self, from: data)
                completion(.success(conversations))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func sendMessage(messageInput: MessageInput) {
        guard let webSocketTask = webSocketTask else {
            return
        }

        do {
            let data = try JSONEncoder().encode(messageInput)
            webSocketTask.send(.data(data)) {_ in }
            print("message send")
        } catch {
            print("sendMessage error: \(error)")
        }
    }

    func connect(token: Token, messageHandler: @escaping (Message) -> Void) async {
        guard let socketEndPoint = self.socketEndPoint else {
            return
        }

        var request = URLRequest(url: socketEndPoint)
        request.addValue("Bearer \(token.value)", forHTTPHeaderField: "Authorization")

        self.webSocketTask = URLSession.shared.webSocketTask(with: request)
        self.webSocketTask?.receive(completionHandler: { result in
            self.onReceive(incoming: result, handleMessage: messageHandler)
        })
        self.webSocketTask?.resume()
    }

    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>, handleMessage: @escaping (Message) -> Void) {
        self.webSocketTask?.receive(completionHandler: { result in
            self.onReceive(incoming: result, handleMessage: handleMessage)
        })

        DispatchQueue.main.async {
            switch incoming {
            case .success(let webSocketMessage):
                if case .data(let data) = webSocketMessage {
                    do {
                        let message = try JSONDecoder().decode(Message.self, from: data)
                        handleMessage(message)
                    } catch {}
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
}
