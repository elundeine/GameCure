//
//  UserModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import Foundation


struct User: Encodable, Decodable {
    var uid: String
    var email: String
    var profileImageUrl: String
    var username: String
    var searchName: [String]
    var bio: String
    var challenges: [String]
    var loggedInDates: [String?]
    var completedChallenges: [String : String]?
}
