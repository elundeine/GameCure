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
    var userIds: [String]
    var completed: [Double]?
    var timesCompleted: Int?
    var firstCompleted: Double
    var challengeDuration: Int
    
    
}
