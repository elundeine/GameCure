//
//  ChallengeModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 09.12.20.
//

import Foundation

struct Challenge: Encodable, Decodable {
    var uid: String
    var title: String
    var duration: String
    var interval: String
    var searchName: [String]
    var description: String
    // challengeCreater = uid of creater
    var challengeCreater: String
}
