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

struct SharedChallenge: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var title: String
    var challengeId: String
    var durationDays: Int
    var interval: String
    var searchName: [String]
    var completedChallenge: [String : String]?
    var description: String
    var userId: String
    var challengeCreator: String
    var challengerUserId: String
    var challengerUsername: String
    @ServerTimestamp var createdTime: Timestamp?
}
