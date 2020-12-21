//
//  ChallengeModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 09.12.20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Challenge: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var durationDays: String
    var interval: String
    var searchName: [String]
    var description: String
    var completed: Bool
    var challengeCreater: String
    var userIds: [String]?
    @ServerTimestamp var createdTime: Timestamp?
}


#if DEBUG
//let testDataChallenges = [
//    Challenge(id: "123", title: "water", durationDays: "7", interval: "1", searchName: ["w","a","t","e","r"] , description: "drink enough water a day for one week",completed: false,  challengeCreater: "Bogus"),
//    Challenge(id: "1234", title: "beer", durationDays: "14", interval: "1", searchName: ["b","e","e","r"] , description: "drink enough beer a day for two week", completed: false, challengeCreater: "Bogus"),
//    Challenge(id: "12345", title: "wine", durationDays: "31", interval: "1", searchName: ["w","i","n","e"] , description: "drink enough wine a day for one month", completed: false, challengeCreater: "Bogus")
//]
#endif

