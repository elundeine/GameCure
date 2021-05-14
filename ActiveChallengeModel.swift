//
//  ActiveChallengeModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.05.21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ActiveChallenge: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var title: String
    var challengeId: String
    var durationDays: Int
    var interval: String
    var description: String
    var completed: Bool
    var challengeCreater: String
    var userId: String
    @ServerTimestamp var createdTime: Timestamp?
}


