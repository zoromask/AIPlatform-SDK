//import Foundation
//
//class WebSocketManager: ObservableObject {
//    private var webSocketTask: URLSessionWebSocketTask?
//    @Published var messages: [String] = []
//
//    func connect() {
//        let url = URL(string: "ws://localhost:3000")!
//        webSocketTask = URLSession.shared.webSocketTask(with: url)
//        webSocketTask?.resume()
//        print("Connected to server")
//        joinRoom(room: "test")
//        receiveMessage()
//    }
//    
//    func joinRoom(room: String) {
//        print("Joining room \(room)")
//        let joinMessage = ["event": "joinRoom", "data": room]
//        guard let data = try? JSONSerialization.data(withJSONObject: joinMessage, options: []) else { return }
//
//        let message = URLSessionWebSocketTask.Message.data(data)
//        webSocketTask?.send(message) { error in
//            if let error = error {
//                print("Error joining room: \(error)")
//            } else {
//                print("Joined room: \(room)")
//            }
//        }
//    }
//
//    func disconnect() {
//        webSocketTask?.cancel(with: .normalClosure, reason: nil)
//        print("Disconnected from server")
//    }
//
//    func sendMessage(message: String) {
//        let messageData = ["event": "message", "data": ["room": "test", "text": message]]
//        guard let data = try? JSONSerialization.data(withJSONObject: messageData, options: []) else { return }
//
//        let message = URLSessionWebSocketTask.Message.data(data)
//        webSocketTask?.send(message) { error in
//            if let error = error {
//                print("WebSocket sending error: \(error)")
//            }
//        }
//    }
//
//    func receiveMessage() {
//        webSocketTask?.receive { [weak self] result in
//            switch result {
//            case .failure(let error):
//                print("WebSocket receiving error: \(error)")
//            case .success(let message):
//                switch message {
//                case .string(let text):
//                    self?.handleReceivedMessage(text)
//                case .data(let data):
//                    self?.handleReceivedData(data)
//                @unknown default:
//                    fatalError()
//                }
//            }
//
//            // Continue receiving messages
//            self?.receiveMessage()
//        }
//    }
//
//    private func handleReceivedMessage(_ text: String) {
//        print("Received message: \(text)")
//        DispatchQueue.main.async {
//            self.messages.append(text)
//        }
//    }
//
//    private func handleReceivedData(_ data: Data) {
//        print("Received data: \(data)")
//        // Decode data if needed
//        if let text = String(data: data, encoding: .utf8) {
//            handleReceivedMessage(text)
//        }
//    }
//}
