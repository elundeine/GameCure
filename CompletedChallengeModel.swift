//
//  CompletedChallengeModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 27.12.20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CompletedChallenge: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var challengeId: String
    var userId: String
    var completed: [Double]?
    var timesCompleted: Int?
    var firstCompleted: Double
    var challengeDuration: Int
}
