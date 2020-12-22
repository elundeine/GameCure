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
    @Published var userChallenges = [Challenge]()
    @Published var challengeCategories = [ChallengeCategory]()
    
    
    init() {
        loadChallenges()
        loadDataForUser()
        loadDataForCategory()
    }
    private func loadChallenges() {
        db.collection("challenges").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
              self.challenges = querySnapshot.documents.compactMap { document -> Challenge? in
                try? document.data(as: Challenge.self)
              }
            }
          }
    }
    
 
    private func loadDataForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print(userId)
          db.collection("challenges")
            .whereField("userIds", arrayContains: userId)
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
                print("in querySnapshot")
                self.userChallenges = querySnapshot.documents.compactMap { document -> Challenge? in
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
            let result = try db.collection("challenges").addDocument(from: challenge)
            print(result.documentID)
            updateCategory(challengeId: result.documentID, challengeName: challenge.title, category: challenge.category)
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
    }
    
    func updateCategory(challengeId: String, challengeName: String, category: String) {
            print("updating")
            db.collection("challengecategories").document(category).updateData([
                "challenges.\(challengeId)": challengeName
            ])
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
    
    func checkIfIDoThe(_ challenge: Challenge) -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        guard let challengeUserIds = challenge.userIds else { return false }
        if challengeUserIds.contains(userId) {
            return true
        } else {
            return false
        }
    }
    
    func addChallengeToUser (_ challenge: Challenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print(userId)
        let userRef = db.collection("users").document(userId)
        let date = NSDate(timeIntervalSince1970: TimeInterval(Timestamp(date: Date()).seconds))
        print("\(date)")
        userRef.updateData(["completedChallenges.\(challenge.id)" : "\(Timestamp(date: Date()))"])
    }
}
