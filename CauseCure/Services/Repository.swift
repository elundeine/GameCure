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

class Repository: ObservableObject {
    

    static var storeRoot = Firestore.firestore()
    
    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    let db = Firestore.firestore()
    @Published var challenges = [Challenge]()
    @Published var userChallenges = [Challenge]()
    @Published var userChallengesToday = [Challenge]()
    @Published var challengeCategories = [ChallengeCategory]()
    @Published var users = [User]()
    @Published var following = [User]()
    
    init() {
       
        loadChallenges()
        loadChallengesForUser()
        loadDataForCategory()
        loadUsers()
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
    private func loadUsers() {
//        print("before db collection")
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
//            print("loading user")
            if let querySnapshot = querySnapshot {
                
//                  print("in querySnapshot of users")
              self.users = querySnapshot.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
              }
            }
        }
    }
    
    private func loadFollowing() {
        //NOT USED ATM
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        db.collection("users").document(userId).getDocument { (querySnapshot, error) in
//            if let error = error {
//                print("error getting document")
//            } else if let querySnapshot = querySnapshot {
//                for 
//            }
//            
//        }
        //Todo: This should be in a different repository?
        //      Or we should rename the Challenge Repository to a general repository

    }
    //Todo: This should be in a different repository?
    //      Or we should rename the Challenge Repository to a general repository
    
 
    private func loadChallengesForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
//        print(userId)
          db.collection("challenges")
            .whereField("userIds", arrayContains: userId)
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
                self.userChallenges = querySnapshot.documents.compactMap { document -> Challenge? in
                  try? document.data(as: Challenge.self)
                }
              }
            }
        }
    private func loadTodaysChallengesForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
//        print(userId)
          db.collection("challenges")
            .whereField("userIds", arrayContains: userId)
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
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
//            print("updating")
            db.collection("challengecategories").document(category).updateData([
                "challenges.\(challengeId)": challengeName
            ])
    }
    
    
    //Mark: User functions updates
    func addChallengeToUser(_ challenge: Challenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData([
            "challenges.\(challenge.id)": ""
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
    
    func completeChallenge (_ challenge: Challenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
//        print(userId)
        let userRef = db.collection("users").document(userId)
             
        let date = NSDate(timeIntervalSince1970: TimeInterval(Timestamp(date: Date()).seconds))
        print("\(date)")
        userRef.updateData(["completedChallenges.\(String(describing: challenge.id))" : "\(Timestamp(date: Date()))"])
//        let experience = userRef.get("experience") as! Int
        let docRef = Firestore.firestore().collection("users").document(userId ?? "")
                
                // Get data
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data()
                        if dataDescription?["experience"] != nil {
                            let experience = dataDescription?["experience"] as! Int
                            userRef.updateData(["experience" : (experience + 50 )])
                        } else {
                            userRef.updateData(["experience" : (50)])
                        }
                    } else {
                        print("Document does not exist")
                        
                        
                    }
                }
        
        
        guard let challengeId = challenge.id else { return }
        let challengeRef = db.collection("challenges").document(challengeId)
        challengeRef.updateData(["completedBy.\(Timestamp(date: Date()))" : "\(String(describing: userId))"])
    }
    
    func getChallengeStreak (_ challenge: Challenge) {
        //TODO
    }
    
    func followUser (userIdToFollow: String, usernameToFollow: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData([
            "following.\(userIdToFollow)": "\(usernameToFollow)"])
        print("\(userId) now following \(userIdToFollow)")
        
        db.collection("users").document(userIdToFollow).updateData([
            "followers.\(userId)": "\(usernameToFollow)"
        ])
        print("\(userIdToFollow) now has a new follower \(userId)")
    
    }
    
    
    func checkIfCompletedToday (_ challenge: Challenge, user: User) -> Bool {
        guard let userId = user.uid else { return false }
        let valuesForKeys = user.completedChallenges?.valuesForKeys(keys: ["drOPQwKJraX3KE54vOCrnLYSOIo2"])
        var i = 0
        for value in valuesForKeys ?? [] {
            print(i)
            print(value)
            i += 1
        }
        return true
    }
    
    func updateUser(_ user: User) {
         if let userID = user.uid {
            do {
                try db.collection("users").document(userID).setData(from: user)
            } catch {
                fatalError("Unable to encode challenge: \(error.localizedDescription)")
            }
        }
    }
}


extension Dictionary {
    func valuesForKeys(keys: [Key]) -> [Value?] {
            return keys.map { self[$0] }
        }
}

