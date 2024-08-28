//
//  ChatViewModel.swift
//  
//
//  Created by Mac on 7/17/24.
//

import Foundation

struct Content: Codable {
    let id: String
    let response: String
}

struct MessageResponse: Codable {
    let content: Content
}

struct SKResponse: Codable {
    let event: String
    let data: SKResponseData
}

struct SKResponseData: Codable {
    let room: String?
    let message: String?
}

class ChatViewModel: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var messages: [ChatMessage] = []
    @Published var currentMessage: String = ""
    var typeChat: String = "bot"
    
    func toggleLike(for message: ChatMessage, isLike: Bool) {
        
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            let oldStatus: Bool? = messages[index].isLike
            var status: Bool? = nil
            if isLike {
                status = oldStatus == nil ? true : nil
            } else {
                status = oldStatus == nil ? false : nil
            }
            messages[index].isLike = status
        }
    }
    
    func openBoxchat() {
//        greeting()
    }
    
    func greeting() {
        let currentTime = getCurrentTimeFormatted()
        DispatchQueue.main.async {
            let newMessage = ChatMessage(
                text: "Chào bạn, tôi có thể giúp gì cho bạn!",
                isLike: nil,
                created_at: currentTime,
                type: MessageType(rawValue: 2)!,
                isUserMessage: false
            )
            self.messages.append(newMessage)
        }
    }
    
    func connect() {
        let url = URL(string: "ws://localhost:3000")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        joinRoom(room: "test")
        socketReceiveMessage()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        print("Disconnected from server")
    }
    
    func joinRoom(room: String) {
        print("Joining room \(room)")
        let joinMessage: [String: Any] = [
            "event": "joinRoom",
            "data": [
                "room": room
            ]
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: joinMessage, options: []) else { return }

        let message = URLSessionWebSocketTask.Message.data(data)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error joining room: \(error)")
            } else {
                print("Joined room: \(room)")
            }
        }
    }
    
    func handleReceivedMessage(text: String, type: MessageType) {
        let currentTime = getCurrentTimeFormatted()
        DispatchQueue.main.async {
            let newMessage = ChatMessage(
                text: text,
                isLike: nil,
                created_at: currentTime,
                type: type,
                isUserMessage: false
            )
            self.messages.append(newMessage)
        }
    }
    
    func socketReceiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
                case .failure(let error):
                    print("WebSocket receiving error: \(error)")
                case .success(let message):
                    switch message {
                        case .string(let data):
                            do {
                                let jsonObject = try JSONDecoder().decode(SKResponse.self, from: data.data(using: .utf8)!)
                                switch jsonObject.event {
                                    case "sendMessage":
                                    if (self?.typeChat == "human") {
                                            if let message = jsonObject.data.message {
                                                self?.handleReceivedMessage(
                                                    text: message,
                                                    type: MessageType(rawValue: 2)!
                                                )
                                            }
                                        }
                                    default:
                                        print("Event empty")
                                }
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                        default:
                            print("Empty")
                    }
            }
            // Continue receiving messages
            self?.socketReceiveMessage()
        }
    }

    
    func sendMessage() {
        if currentMessage.isEmpty {
            return
        }
        // change bot to socket
        if (currentMessage == "Tvv") {
            if typeChat == "bot" {
                self.connect()
                let currentTime = getCurrentTimeFormatted()
                let content = currentMessage
                typeChat = "human"
                DispatchQueue.main.async {
                    let newMessage = ChatMessage(
                        text: content,
                        created_at: currentTime,
                        type: MessageType(rawValue: 1)!,
                        isUserMessage: true
                    )
                    self.messages.append(newMessage)
                    self.currentMessage = ""
                    self.handleReceivedMessage(
                        text: "Xin vui lòng đợi trong giây lát,sẽ có tư vấn viên hỗ trợ bạn.",
                        type: MessageType(rawValue: 2)!
                    )
                }
                return
            } else {
                sendMessageToSocket()
            }
        } else {
            if (typeChat == "human") {
                sendMessageToSocket()
            } else if (typeChat == "bot") {
                sendMessageToChatbot()
            }
        }
    }
    
    func sendMessageToSocket() {
        let currentTime = getCurrentTimeFormatted()
        let content = currentMessage
        DispatchQueue.main.async {
            let newMessage = ChatMessage(
                text: content,
                created_at: currentTime,
                type: MessageType(rawValue: 2)!,
                isUserMessage: true
            )
            self.messages.append(newMessage)
        }
        let sendMessage: [String: Any] = [
            "event": "sendMessage",
            "data": [
                "room": "test",
                "message": content
            ]
        ]
        currentMessage = ""
        
        guard let data = try? JSONSerialization.data(withJSONObject: sendMessage, options: []) else { return }

        let message = URLSessionWebSocketTask.Message.data(data)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error send mess to room: \(error)")
            } else {
                print("send mess to room success")
            }
        }
    }
    
    func sendMessageToChatbot() {
        let currentTime = getCurrentTimeFormatted()
        let content = currentMessage
        DispatchQueue.main.async {
            let newMessage = ChatMessage(
                text: content,
                created_at: currentTime,
                type: MessageType(rawValue: 1)!,
                isUserMessage: true
            )
            self.messages.append(newMessage)
        }
        currentMessage = ""
        
        // execute api
        guard let url = URL(string: "https://tenant-caip.vpbank.com.vn/api/conversation/web-ops-smeconnect/chat") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("user-id", forHTTPHeaderField: "1299fb7d-cbfa-48cf-8e96-38cc2f0dabcd")

        let parameters = ["content": content]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let api = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error) ")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response: \(String(describing: response))")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MessageResponse.self, from: data)
                    self.handleReceivedMessage(
                        text: response.content.response,
                        type: MessageType(rawValue: 1)!
                    )
                } catch {
                    print("Error decoding response: \(error)")
                }
            }
        }

        api.resume()
    }
    
    func saveMessages() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(messages) {
            UserDefaults.standard.set(encoded, forKey: "savedMessages")
        }
    }
    
    func loadMessages() {
        if let savedMessages = UserDefaults.standard.object(forKey: "savedMessages") as? Data {
            let decoder = JSONDecoder()
            if let loadedMessages = try? decoder.decode([ChatMessage].self, from: savedMessages) {
                messages = loadedMessages
            }
        }
    }

}
