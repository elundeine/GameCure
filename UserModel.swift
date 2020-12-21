//
//  UserModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import Foundation
import FirebaseFirestoreSwift


struct User: Encodable, Decodable {
    var uid: String
    var email: String
    var profileImageUrl: String
    var username: String
    var searchName: [String]
    var bio: String
    var challenges: [String]
    var loggedInDates: [String?]
    @ServerTimestamp var completedChallenges: [String : Timestamp]?
}
