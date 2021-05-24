//
//  InviteModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 07.05.21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Invite: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var challengedUserId: String
    var challengedUsername: String
    var challengerUserId: String
    var challengerUsername: String
    var challengeId: String
    var challengeTitle: String
    var challengeDescription: String
    var challengeCreater: String
    var challengeInterval: String
    var durationDays: Int
    var shared: Bool
}
