//
//  ChallengeCategoryModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 21.12.20.
//
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChallengeCategory: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var challenges: [String : Bool]
}
