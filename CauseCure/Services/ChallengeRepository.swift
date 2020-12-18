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
import Combine

class ChallengeRepository: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var challenges = [Challenge]()
    
    
    func loadData() {
        db.collection("challenges").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.challenges = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Challenge.self)
                }
            }
        }
    }
}
