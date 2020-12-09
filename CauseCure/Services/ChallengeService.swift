//
//  ChallengeService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 09.12.20.
//


import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class ChallengeService {

    static var storeRoot = Firestore.firestore()

    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
}
