//
//  MessageModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 03.04.21.
//

import Foundation

struct Message: Encodable, Decodable, Identifiable {
    var id = UUID()
    var lastMessage: String
    var username: String
    var isPhoto: Bool
    var timestamp: Double
    var userID: String
    var profile: String
}
