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
    var loggedInDates: [String]?
    var following: [String]?
    var followers: [String]?
    var completedChallenges: [String : String]?
    var completedTour: Bool
    var doneChallenges: [String]?
    var chats: [String : String]?
    var description: DescriptionModel?
    var stats: StatsModel?
    
    
//    private enum CodingKeys: String, CodingKey {
//        case uid
//        case email
//        case profileImageUrl
//        case username
//        case experience
//        case searchName
//        case bio
//        case loggedInDates
//        case following
//        case followers
//        case completedChallenges
//        case completedTour
//        case doneChallenges
//        case chats
//        case description
//        case stats
//
//    }
//    required init(from decoder:Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        uid = try values.decode(String.self, forKey: .uid)
//        email = try values.decode(String.self, forKey: .email)
//        profileImageUrl = try values.decode(String.self, forKey: .profileImageUrl)
//        username = try values.decode(String.self, forKey: .username)
//        experience = try values.decode(Int.self, forKey: .experience)
//        searchName = try values.decode([String].self, forKey: .searchName)
//        bio = try values.decode(String.self, forKey: .bio)
//        loggedInDates = try values.decode([String].self, forKey: .loggedInDates)
//        following = try values.decode([String].self, forKey: .following)
//        followers = try values.decode([String].self, forKey: .followers)
//        completedChallenges = try values.decode([String:String].self, forKey: .completedChallenges)
//        completedTour = try values.decode(Bool.self, forKey: .completedTour)
//        doneChallenges = try values.decode([String].self, forKey: .doneChallenges)
//        chats = try values.decode([String:String].self, forKey: .chats)
//        description = try values.decode(DescriptionModel.self, forKey: .description)
//        stats = try values.decode(StatsModel.self, forKey: .stats)
//    }
    init(uid: String?, email: String,profileImageUrl: String,username: String, experience: Int,searchName: [String],bio: String, loggedInDates: [String]?, following: [String]?, followers: [String]?, completedChallenges: [String : String]?, completedTour: Bool, doneChallenges: [String]?, chats: [String : String]?,  description: DescriptionModel?, stats: StatsModel?){
        self.uid = uid
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.experience = experience
        self.searchName = searchName
        self.bio = bio
        self.loggedInDates = loggedInDates
        self.following = following
        self.followers = followers
        self.completedChallenges = completedChallenges
        self.completedTour = completedTour
        self.doneChallenges = doneChallenges
        self.chats = chats
        self.description = description
        self.stats = stats
    }
//    func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(uid, forKey: .uid)
//
//        }
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
