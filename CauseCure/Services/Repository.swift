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

// MARK: This service handels all User linked Challenges and loads the data upon View initialisation for the View Models.

class Repository: ObservableObject {
    

    static var storeRoot = Firestore.firestore()
    
    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    let db = Firestore.firestore()

    @Published var userChallenges = [Challenge]()
    @Published var userChallengesToday = [Challenge]()
    @Published var userSharedChallenges = [Challenge]()
    @Published var challengeCategories = [ChallengeCategory]()
    @Published var completedUserChallenges = [CompletedChallenge]()
    @Published var sharedCompletedUserChallenges = [CompletedChallenge]()
    @Published var users = [User]()
    @Published var following = [User]()
    @Published var messages = [Message]()
    @Published var userChallengeInvites = [Challenge]()
    @Published var userSharedChallengeInvites = [Challenge]()
    typealias finished = () -> ()
    init() {
       
//      loadChallenges()
        loadChallengesForUser()
        loadSharedChallengesForUser()
        loadDataForCategory()
//        loadUsers()
//      loadMessages()
//      loadSharedCompletedUserChallenges()
        loadCompletedUserChallenges()
        loadUserChallengeInvites()
        loadUserSharedChallengeInvites()
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
    
    
        
        
    //creating a snapshot for all users in order to search for users.
//    private func loadUsers() {
////        print("before db collection")
//        db.collection("users").addSnapshotListener { (querySnapshot, error) in
////            print("loading user")
//            if let querySnapshot = querySnapshot {
//
////                  print("in querySnapshot of users")
//              self.users = querySnapshot.documents.compactMap { document -> User? in
//                try? document.data(as: User.self)
//              }
//            }
//        }
//    }
    
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
    
    private func loadSharedChallengesForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
            db.collection("challenges")
                .addSnapshotListener { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        let challenges = querySnapshot.documents.compactMap { document -> Challenge? in
                            try? document.data(as: Challenge.self)
                        }
                        for challenge in challenges {
                            
                            if (challenge.sharedUserIds != nil){
                                for (key, value) in challenge.sharedUserIds!{
                                    if (key == userId) {
                                        self.userSharedChallenges.append(challenge)
                                        self.loadSharedCompletedUserChallenges(userId: value, challengeId: challenge.id!)
                                    
                                    } else {
                                        if (value == userId) {
                                            self.userSharedChallenges.append(challenge)
                                            self.loadSharedCompletedUserChallenges(userId: key, challengeId: challenge.id!)
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func loadSharedCompletedUserChallenges(userId: String, challengeId: String) {
       
        db.collection("completedChallenges").whereField("userId", isEqualTo: userId).whereField("challengeId", isEqualTo: challengeId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
              self.sharedCompletedUserChallenges = querySnapshot.documents.compactMap { document -> CompletedChallenge? in
                try? document.data(as: CompletedChallenge.self)
              }
            }
          }

    }
    
    func getSharedChallengeFromUser(userId: String) {
        
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
    //TODO
    private func loadUserChallengeInvites() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print(userId)
          db.collection("challenges")
            .whereField("invitedUserIds", arrayContains: userId)
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
                print("Found SOMETHING")
                self.userChallengeInvites = querySnapshot.documents.compactMap { document -> Challenge? in
                  try? document.data(as: Challenge.self)
                }
              }
            }
        }
    private func loadUserSharedChallengeInvites() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
          db.collection("challenges")
            .whereField("invitedSharedUserIds", arrayContains: userId)
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
                self.userSharedChallengeInvites = querySnapshot.documents.compactMap { document -> Challenge? in
                  try? document.data(as: Challenge.self)
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
    
    func challengeDone(challenge: Challenge, timesCompleted: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        removeChallengefromUser(challenge)
        
        db.collection("users").document(userId).updateData(["doneChallenges": FieldValue.arrayUnion(["\(challenge.id)"])])
        
    }
    
    func updateCategory(challengeId: String, challengeName: String, category: String) {
//            print("updating")
            db.collection("challengecategories").document(category).updateData([
                "challenges.\(challengeId)": challengeName
            ])
    }
    
    func addChallengeToUser(_ challenge: Challenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData([
            "challenges.\(challenge.id)": ""
        ])
        
    }
    
    //TODO
    func removeChallengefromUser(_ challenge: Challenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("challenges").document(challenge.id ?? "").updateData(["userIds" : FieldValue.arrayRemove(["\(userId)"])])
    }
    
    func sendChallengeInvite (userId: String, myUsername: String, challengeId: String) {
        print("send Challenge Invite")
        db.collection("users").document(userId).updateData([
            "pendingChallengeInvite.\(challengeId)": "\(myUsername)"])
        db.collection("challenges").document(challengeId).updateData(["invitedUserIds" : FieldValue.arrayUnion(["\(userId)"])])
        print("\(userId) got invited to do \(challengeId)")
        
    }
    func sendSharedChallengeInvite (userId: String, myUsername: String, challengeId: String) {
        print("send SHARED Challenge Invite")
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).updateData([
            "pendingSharedChallengeInvite.\(challengeId)": "\(myUserId)"])
        db.collection("challenges").document(challengeId).updateData(["invitedSharedUserIds" : FieldValue.arrayUnion(["\(userId)"])])
        print("\(userId) got invited to do \(challengeId)")
    }
    
    func deleteChallengeInviteFrom (challengeId: String) {
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(myUserId).updateData([
            "pendingChallengeInvite.\(challengeId)": FieldValue.delete()])
        db.collection("challenges").document(challengeId).updateData(["invitedUserIds" : FieldValue.arrayRemove(["\(myUserId)"])])
        
    }
    func acceptChallengeInviteFrom (userId: String, challengeId: String) {
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(myUserId).updateData([
            "challenges.\(challengeId)": userId
        ])
        
        db.collection("challenges").document(challengeId).updateData(["userIds" : FieldValue.arrayUnion(["\(myUserId)"])])
        deleteChallengeInviteFrom(challengeId: challengeId)
        print("\(userId) got invited to do \(challengeId)")
    }
    
    func acceptSharedChallengeInviteFrom (userId: String, challengeId: String) {
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(myUserId).updateData([
            "sharedChallenges.\(challengeId)": userId
        ])
        db.collection("users").document(userId).updateData([
            "sharedChallenges.\(challengeId)": myUserId
        ])
        db.collection("challenges").document(challengeId).updateData(["sharedUserIds.\(userId)": "\(myUserId)"])
        deleteSharedChallengeInviteFrom(challengeId: challengeId)
        
    }
    
    func deleteSharedChallengeInviteFrom (challengeId: String) {
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(myUserId).updateData([
            "pendingSharedChallengeInvite.\(challengeId)": FieldValue.delete()])
        db.collection("challenges").document(challengeId).updateData(["invitedSharedUserIds" : FieldValue.arrayRemove(["\(myUserId)"])])
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
    
    func completeAChallenge(challenge: Challenge, username: String) {
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
                        let newCompletedChallengesID = self.addNewCompletedChallenge(challenge, userId: userId, username: username, timeInterval: Date().timeIntervalSince1970)
                        userDocRef.updateData(["completedChallenges.\(newCompletedChallengesID)": "\(challenge.id)"])
                    challengeRef.updateData(["completedChallenges.\(newCompletedChallengesID)": "\(userId)"])
                    print("Completed Challenges Collection was created id: \(newCompletedChallengesID)")
                    }
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
