//
//  ChatMessage.swift
//
//
//  Created by Mac on 7/17/24.
//

import Foundation

enum MessageType: Int, Codable {
    case type1 = 1 // chat with bot
    case type2 = 2 // chat with human
}

// Model for a chat message
struct ChatMessage: Identifiable, Equatable, Codable {
    var id = UUID()
    let text: String
    var isLike: Bool? = nil
    let created_at: String
    var type: MessageType
    let isUserMessage: Bool
}
