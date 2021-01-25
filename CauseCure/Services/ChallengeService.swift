//
//  ChallengeService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 07.01.21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import SwiftUI

// MARK: This service loads all globally created Challenges


class ChallengeService: ObservableObject {
    
    static var storeRoot = Firestore.firestore()
    
    let db = Firestore.firestore()
    
    @Published var challenges = [Challenge]()
    init() {
        loadChallenges()
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
//            print("updating")
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
    
    func addUserToChallenge( challengeId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        //            print("updating")
        db.collection("challenges").document(challengeId).updateData(["userIds" : FieldValue.arrayUnion(["\(userId)"])])
            
    }
    
    
    func getUsernameBy(_ userId: String) -> String {
        let userRef = db.collection("users").document(userId)
        var username = ""
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("exists")
                let dataDescription = document.data()
                if dataDescription?["username"] != nil {
                    username = dataDescription?["username"] as! String
                    print("username")
                    print(username)
                }
            }
        }
        print(username)
        return username
    }
    
    func completeAChallenge(challenge: Challenge, username: String) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("users").document(userId)
        var completedUserChallengesIDs = [String]()
        let userDocRef = Firestore.firestore().collection("users").document(userId )
        let challengeRef = Firestore.firestore().collection("challenges").document(challenge.id ?? "")
        userDocRef.getDocument { (document, error) in
            print("get document")
            if let document = document, document.exists {
                let dataDescription = document.data()
                if dataDescription?["completedChallenges"] != nil {
                    print("user has completed some challenges")
                    
                    let completedChallengesByUser = dataDescription!["completedChallenges"] as! Dictionary<String, String>
                    for (key, _) in completedChallengesByUser {

                        print("user completedChallenges IDs \(key)")
                        
                        let completedChallengeRef = self.db.collection("completedChallenges").document(key)
                        completedChallengeRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let dataDescription = document.data()
                                if dataDescription?["challengeId"] != nil  && dataDescription?["userId"] != nil {
                                    guard let completedChallengeId = dataDescription?["challengeId"] as? String else {return}
                                    if completedChallengeId == challenge.id {
                                        // add new entry
                                        //challenge already has
                                        completedChallengeRef.updateData(["completed" : FieldValue.arrayUnion([Date().timeIntervalSince1970])])
                                        return
                                    }
                                }
                            }
                        }
                    }
                    print("non of the user completedChallenges is equal to \(challenge.id), we create a new Completed Challenges Collection")
                    let newCompletedChallengesID = self.addNewCompletedChallenge(challenge, userId: userId, username: username, timeInterval: Date().timeIntervalSince1970)
                    userDocRef.updateData(["completedChallenges.\(newCompletedChallengesID)": challenge.id])
                    challengeRef.updateData(["completedChallenges.\(newCompletedChallengesID)": userId])
                    print("Completed Challenges Collection was created id: \(newCompletedChallengesID)")
                
            } else {
                print("user \(userId) has never completed a challenge")
                let newCompletedChallengesID = self.addNewCompletedChallenge(challenge, userId: userId, username: username, timeInterval: Date().timeIntervalSince1970)
                userDocRef.updateData(["completedChallenges.\(newCompletedChallengesID)": challenge.id])
                challengeRef.updateData(["completedChallenges.\(newCompletedChallengesID)": userId])
                print("first Completed Challenges Collection was created id: \(newCompletedChallengesID)")
            
            }
        }
        
        }
    }
    
    func addNewCompletedChallenge(_ challenge: Challenge, userId: String, username: String, timeInterval: Double) -> String {
        
        
        do {
            print("adding")
            
            let result = try self.db.collection("completedChallenges").addDocument(from: CompletedChallenge(challengeId: challenge.id ?? "", userId: userId, username: username, completed: [timeInterval], timesCompleted: 1, firstCompleted: timeInterval, challengeDuration: challenge.durationDays))
            print(result.documentID)
            return result.documentID
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
    }
        
    
//    func updateCompletedChallenge(challengeId: String, challengeName: String, category: String) {
////            print("updating")
//            db.collection("completedChallenges").document(category).updateData([
//                "challenges.\(challengeId)": challengeName
//            ])
//    }
//
    
    
    
    func checkIfIDoThe(_ challenge: Challenge) -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        guard let challengeUserIds = challenge.userIds else { return false }
        if challengeUserIds.contains(userId) {
            return true
        } else {
            return false
        }
    }
}
