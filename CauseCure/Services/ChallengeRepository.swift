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
import FirebaseFirestoreSwift
import Combine
import SwiftUI

class ChallengeRepository: ObservableObject {
    
    @EnvironmentObject var session: SessionStore
    static var storeRoot = Firestore.firestore()
    
    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    let db = Firestore.firestore()
    @Published var challenges = [Challenge]()
    @Published var challengeCategories = [ChallengeCategory]()
    init() {
        loadDataForUser()
        loadDataForCategory()
    }
 
    private func loadDataForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print(userId)
          db.collection("challenges")
            .whereField("userIds", arrayContains: userId)
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
                print("in querySnapshot")
                self.challenges = querySnapshot.documents.compactMap { document -> Challenge? in
                  try? document.data(as: Challenge.self)
                }
              }
            }
        }
        
    private func loadDataForCategory() {
          db.collection("challengecategories")
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
                print("in querySnapshot of challenge categories")
                self.challengeCategories = querySnapshot.documents.compactMap { document -> ChallengeCategory? in
                  try? document.data(as: ChallengeCategory.self)
                }
              }
            }
        }
    
    func addChallenge(_ challenge: Challenge) {
        do {
            print("adding")
            let _ = try db.collection("challenges").addDocument(from: challenge)
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
    }
    
    func updateChallenge(_ challenge: Challenge) {
        if let challengeID = challenge.id {
            do {
                try db.collection("challenges").document(challengeID).setData(from: challenge)
            } catch {
                fatalError("Unable to encode challenge: \(error.localizedDescription)")
            }
        }
    }
    
    func addChallengeToUser (_ challenge: Challenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print(userId)
        let userRef = db.collection("users").document(userId)
        userRef.updateData(["completedChallenges" : [challenge.id : "\(Timestamp(date: Date())))"]])
    }
}
