//
//  UserModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable, Hashable {
    var uid: String?
    var email: String
    var profileImageUrl: String
    var username: String
    var experience: Int
    var searchName: [String]
    var bio: String
    var loggedInDates: [String?]
    var following: [String : String]?
    var followers: [String : String]?
    var completedChallenges: [String : String]?
    var completedTour: Bool
    var pendingChallengeInvite: [String : String]?
    var description: DescriptionModel?
    var stats: StatsModel?
}

extension User: Identifiable {
    var id: User { self }
}

struct DescriptionModel: Codable, Hashable {
    var description: String?
    var showDescription: Bool
    var age: String?
    var showAge: Bool
    var numberOfStones: String?
    var showNumberOfStones: Bool
    var biggestStone: String?
    var showBiggestStone: Bool
    var mood: String?
    var showMood: Bool
    var title: String?
    var showTitle: Bool
}

struct StatsModel: Codable, Hashable {
    var challengesFinished: Bool
    var currentChallenges: Bool
    var activeSince: Bool
}
