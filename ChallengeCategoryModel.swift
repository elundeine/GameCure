//
//  ChallengeCategorieModel.swift
//  CauseCure
//
//  Created by Oscar Lange on 12/21/20.
//


import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChallengeCategory: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var challenges: [String : String]
}
