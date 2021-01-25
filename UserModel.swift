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
    var pendingSharedChallengeInvite: [String : String]?
    var doneChallenges: [String]?
    var chats: [String : String]?
    var sharedChallenges: [String : String]?
}

extension User: Identifiable {
    var id: User { self }
}
