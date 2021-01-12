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
import UIKit

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
    @Published var completedUserChallenges = [CompletedChallenge]()
    @Published var users = [User]()
    @Published var following = [User]()
    @Published var messages = [Message]()
    typealias finished = () -> ()
    init() {
       
//        loadChallenges()
        loadChallengesForUser()
        loadDataForCategory()
        loadUsers()
        loadMessages()
        loadCompletedUserChallenges()
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
    
    private func loadCompletedUserChallenges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("completedChallenges").whereField("userId", isEqualTo: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
              self.completedUserChallenges = querySnapshot.documents.compactMap { document -> CompletedChallenge? in
                try? document.data(as: CompletedChallenge.self)
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
    
    private func loadMessages() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("messages").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.messages = querySnapshot.documents.compactMap { document -> Message? in
                try? document.data(as: Message.self)
              }
            }
        }
    }
    
    func sendChallengeInvite (userId: String, myUsername: String, challengeId: String) {
        guard let myId = Auth.auth().currentUser?.uid else { return }
                    
        db.collection("users").document(userId).updateData([
            "pendingChallengInvite.\(challengeId)": "\(myUsername)"])
        print("\(userId) got invited to do \(challengeId)")
    }
    
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
    
    func addMessage(_ message: Message) {
        do {
            print("adding")
            let result = try db.collection("messages").addDocument(from: message)
            print(result.documentID)
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
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
    
    
    func completeAChallenge(_ challenge: Challenge) {
        let group = DispatchGroup()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("users").document(userId)
        let userDocRef = Firestore.firestore().collection("users").document(userId )
        let challengeRef = Firestore.firestore().collection("challenges").document(challenge.id ?? "")
        userDocRef.getDocument { (document, error) in
            print("get user document")
            if let document = document, document.exists {
                let dataDescription = document.data()
                if dataDescription?["completedChallenges"] != nil {
                    print("user has completed some challenges")
                    
                    let completedChallengesByUser = dataDescription!["completedChallenges"] as! Dictionary<String, String>
                    group.enter()
//                    DispatchQueue.global(){
                    print("group enter")
                    for (key, _) in completedChallengesByUser {
                        
                        print("user completedChallenges IDs \(key)")
                        group.enter()
                        let completedChallengeRef = self.db.collection("completedChallenges").document(key)
                        completedChallengeRef.getDocument { (completedChallengeDocument, error) in
                            print("get completed Challenge by user")
                            if let completedChallengeDocument = completedChallengeDocument, completedChallengeDocument.exists {
                                let completedChallengedataDescription = completedChallengeDocument.data()
                                if completedChallengedataDescription?["challengeId"] != nil  && completedChallengedataDescription?["userId"] != nil {
                                    guard let completedChallengeId = completedChallengedataDescription?["challengeId"] as? String else {return}
                                    if completedChallengeId == challenge.id {
                                        print("found the completed Challenge ID of the challenge")
                                        // add new entry
                                        //challenge already has
                                        let timesCompleted = completedChallengedataDescription?["timesCompleted"] as! Int
                                        completedChallengeRef.updateData(["completed" : FieldValue.arrayUnion([Date().timeIntervalSince1970])])
                                        completedChallengeRef.updateData(["timesCompleted" : (timesCompleted + 1 )])
                                        if dataDescription?["experience"] != nil {
                                            let experience = dataDescription?["experience"] as! Int
                                            userRef.updateData(["experience" : (experience + 50 )])
                                        } else {
                                            userRef.updateData(["experience" : (50)])
                                        }
                                        return
                                    }
                                }
                            }
                            group.leave()
                        }
                    }
                    group.leave()
                    print("group leave")
                    group.notify(queue: DispatchQueue.global()) {
                    print("non of the user completedChallenges is equal to \(challenge.id), we create a new Completed Challenges Collection")
                    let newCompletedChallengesID = self.addNewCompletedChallenge(challenge, userId: userId, timeInterval: Date().timeIntervalSince1970)
                        userDocRef.updateData(["completedChallenges.\(newCompletedChallengesID)": "\(challenge.id)"])
                    challengeRef.updateData(["completedChallenges.\(newCompletedChallengesID)": "\(userId)"])
                    print("Completed Challenges Collection was created id: \(newCompletedChallengesID)")
                    }
            } else {
                
                
                print("user \(userId) has never completed a challenge")
                let newCompletedChallengesID = self.addNewCompletedChallenge(challenge, userId: userId, timeInterval: Date().timeIntervalSince1970)
                userDocRef.updateData(["completedChallenges.\(newCompletedChallengesID)": challenge.id])
                challengeRef.updateData(["completedChallenges.\(newCompletedChallengesID)": userId])
                print("first Completed Challenges Collection was created id: \(newCompletedChallengesID)")
            
            }
        }
        
    }
}
    
    
    func addNewCompletedChallenge(_ challenge: Challenge, userId: String, timeInterval: Double) -> String {
        
        
        do {
            print("adding")
            
            let result = try self.db.collection("completedChallenges").addDocument(from: CompletedChallenge(challengeId: challenge.id ?? "", userId: userId, completed: [timeInterval], timesCompleted: 1, firstCompleted: timeInterval, challengeDuration: challenge.durationDays))
            print(result.documentID)
            return result.documentID
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
        
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

