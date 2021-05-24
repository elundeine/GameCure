//
//  SharedChallengeModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.05.21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SharedActiveChallenge: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var title: String
    var userId: String
    var challengeId: String
    var durationDays: Int
    var interval: String
    var description: String
    var userIds: [String]
    var challengeCreator: String
    var challengedUserId: String
    var challengedUsername: String
    var challengerUserId: String
    var challengerUsername: String
    @ServerTimestamp var createdTime: Timestamp?
}
