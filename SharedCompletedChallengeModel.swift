//
//  SharedCompletedChallengeModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 22.01.21.
//
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SharedCompletedChallenge: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var challengeId: String
    var userId: String
    var completed: [Double]?
    var timesCompleted: Int?
    var firstCompleted: Double
    var challengeDuration: Int
    var sharedChallengeId: String
    var sharedWithId: String
    var username: String
}
