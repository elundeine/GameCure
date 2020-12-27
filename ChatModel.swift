//
//  Chat.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 27.12.20.
//

import Foundation
import Firebase


struct Chat: Encodable, Decodable, Hashable {
    var messageId: String
    var textMessage: String
    var profile: String
    var photoUrl: String
    var sender: String
    var username: String
    var timestamp: Double
    var isCurrentUser: Bool {
        return Auth.auth().currentUser!.uid == sender
    }
    var isPhoto:Bool
}
