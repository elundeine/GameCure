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

    @Published var userChallenges = [ActiveChallenge]()
//    @Published var userChallengesToday = [Challenge]()
    @Published var userSharedChallenges = [SharedActiveChallenge]()
    @Published var challengeCategories = [ChallengeCategory]()
    @Published var completedUserChallenges = [CompletedChallenge]()
    @Published var sharedCompletedUserChallenges = [SharedCompletedChallenge]()
    @Published var friendsCompletedUserChallenges = [SharedCompletedChallenge]()
    @Published var users = [User]()
    @Published var invites = [Invite]()
    @Published var following = [User]()
    @Published var followers = [User]()
    @Published var messages = [Message]()
    @Published var userChallengeInvites = [Challenge]()
    @Published var userSharedChallengeInvites = [Challenge]()
    typealias finished = () -> ()
    init() {
//      loadChallenges()
        loadActiveChallengesForUser()
        loadActiveSharedChallengesForUser()
//        print(userChallenges[0].title)
//        loadSharedChallengesForUser()
        loadDataForCategory()
        loadInvites()
//      loadMessages()
//        loadSharedChallenges()
        loadSharedCompletedUserChallenges()
        loadFriendsCompletedUserChallenges()
        loadCompletedUserChallenges()

        loadFollowing()
    }
    
    private func loadCompletedUserChallenges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("completedChallenges").whereField("userId", isEqualTo: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                print("found completed challenge for user")
              self.completedUserChallenges = querySnapshot.documents.compactMap { document -> CompletedChallenge? in
                try? document.data(as: CompletedChallenge.self)
              }
            }
        }
    }
    private func loadSharedChallenges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("sharedChallenges").whereField("userId", arrayContains: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                print("found completed challenge for user")
              self.userSharedChallenges = querySnapshot.documents.compactMap { document -> SharedActiveChallenge? in
                try? document.data(as: SharedActiveChallenge.self)
              }
            }
        }
    }
    private func loadInvites() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("invites").whereField("challengedUserId", isEqualTo: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
              self.invites = querySnapshot.documents.compactMap { document -> Invite? in
                try? document.data(as: Invite.self)
              }
            }
        }
    }
    

    //loading the other users the current logged in user is following
    private func loadFollowing() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").whereField("followers", arrayContains: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
               print( "following a user")
              self.following = querySnapshot.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
              }
            }
        }
    }
    private func loadFollowers() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").whereField("following", arrayContains: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
              self.followers = querySnapshot.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
              }
            }
        }
    }

        
        
    //creating a snapshot for all users in order to search for users.
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
    
    private func loadActiveChallengesForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
//        print(userId)
          db.collection("activeChallenges")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
                self.userChallenges = querySnapshot.documents.compactMap { document -> ActiveChallenge? in
                  try? document.data(as: ActiveChallenge.self)
                }
              }
            }
        }
    
    private func loadActiveSharedChallengesForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
//        print(userId)
          db.collection("sharedActiveChallenges")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
              if let querySnapshot = querySnapshot {
                self.userSharedChallenges = querySnapshot.documents.compactMap { document -> SharedActiveChallenge? in
                  try? document.data(as: SharedActiveChallenge.self)
                }
              }
            }
        }
    
//    private func loadSharedChallengesForUser() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
////        print(userId)
//          db.collection("sharedChallenges")
//            .whereField("userId", arrayContains: userId)
//            .addSnapshotListener { (querySnapshot, error) in
//              if let querySnapshot = querySnapshot {
//                self.userSharedChallenges = querySnapshot.documents.compactMap { document -> SharedActiveChallenge? in
//                  try? document.data(as: SharedActiveChallenge.self)
//                }
//              }
//            }
//        }
    
    
    // OBSOLETE
//    private func loadSharedChallengesForUser() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//            db.collection("challenges")
//                .addSnapshotListener { (querySnapshot, error) in
//                    if let querySnapshot = querySnapshot {
//                        let challenges = querySnapshot.documents.compactMap { document -> Challenge? in
//                            try? document.data(as: Challenge.self)
//                        }
//                        for challenge in challenges {
//
//                            if (challenge.sharedUserIds != nil){
//                                for (key, value) in challenge.sharedUserIds!{
//                                    if (key == userId) {
//                                        self.userSharedChallenges.append(challenge)
//                                        self.loadSharedCompletedUserChallenges(userId: value, challengeId: challenge.id!)
//
//                                    } else {
//                                        if (value == userId) {
//                                            self.userSharedChallenges.append(challenge)
//                                            self.loadSharedCompletedUserChallenges(userId: key, challengeId: challenge.id!)
//                                    }
//                                }
//                            }
//                        }
//                    }
//            }
//        }
//    }

    func loadSharedCompletedUserChallenges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("sharedCompletedChallenges").whereField("userId", isEqualTo: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.sharedCompletedUserChallenges = querySnapshot.documents.compactMap { document -> SharedCompletedChallenge? in
                try? document.data(as: SharedCompletedChallenge.self)
              }
            }
       }
    }
    
    func loadFriendsCompletedUserChallenges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("sharedCompletedChallenges").whereField("sharedWithId", isEqualTo: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.friendsCompletedUserChallenges = querySnapshot.documents.compactMap { document -> SharedCompletedChallenge? in
                try? document.data(as: SharedCompletedChallenge.self)
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
            addChallengeToUser(challenge: challenge, challengeId: result.documentID)
            print(result.documentID)
            updateCategory(challengeId: result.documentID, challengeName: challenge.title, category: challenge.category)
         
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
    }
    
    func challengeDone(challenge: ActiveChallenge, timesCompleted: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        removeChallengefromUser(challenge)
        
        db.collection("users").document(userId).updateData(["doneChallenges": FieldValue.arrayUnion(["\(challenge.challengeId)"])])
        
    }
    
    func sharedChallengeDone(challenge: SharedActiveChallenge, timesCompleted: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        removeSharedChallengefromUser(challenge)
        
        db.collection("users").document(userId).updateData(["doneChallenges": FieldValue.arrayUnion(["\(challenge.challengeId)"])])
        
    }
    func updateCategory(challengeId: String, challengeName: String, category: String) {
    //            print("updating")
            db.collection("challengecategories").document(category).updateData([
                "challenges.\(challengeId)": challengeName
            ])
    }
    
    func addChallengeToUser(challenge: Challenge, challengeId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print("working?")
        do {
            print("adding")
            let result = try db.collection("activeChallenges").addDocument(from: ActiveChallenge(title: challenge.title, challengeId: challengeId, durationDays: challenge.durationDays, interval: challenge.interval, description: challenge.description, completed: false, challengeCreater: challenge.challengeCreater, userId: userId))
            print(result.documentID)
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
    }
    
    
    func removeChallengefromUser(_ challenge: ActiveChallenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("activeChallenges").document(challenge.id ?? "").delete()
    }
    
    func removeSharedChallengefromUser(_ challenge: SharedActiveChallenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("sharedChallenges").document(challenge.id ?? "").delete()
    }
    //TODO
    
    func sendChallengeInvite (challengedUserId: String, challengedUsername: String, myUsername: String, challengeId: String,challengeTitle: String, challengeDescription: String, challengeCreater: String, challengeInterval: String,durationDays: Int, shared: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            print("adding")
            let result = try db.collection("invites").addDocument(from: Invite(challengedUserId: challengedUserId, challengedUsername: challengedUsername, challengerUserId: userId, challengerUsername: myUsername, challengeId: challengeId, challengeTitle: challengeTitle, challengeDescription: challengeDescription, challengeCreater: challengeCreater, challengeInterval: challengeInterval, durationDays: durationDays, shared: shared))
            print(result.documentID)
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
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
    
    //TODO
    
  
    func acceptSharedChallengeInviteFrom (userId: String, invite: Invite) {
        
        if (invite.shared == false){
        do {
            print("adding")
            let result = try db.collection("activeChallenges").addDocument(from: ActiveChallenge(title: invite.challengeTitle, challengeId: invite.challengeId, durationDays: invite.durationDays, interval: invite.challengeInterval, description: invite.challengeDescription, completed: false, challengeCreater: invite.challengeCreater, userId: userId))
            print(result.documentID)
            deleteInvite(invite)
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
        
        } else {
            do {
                print("adding")
                
                //my challenge challenged POV:
                let myResult = try db.collection("sharedActiveChallenges").addDocument(from: SharedActiveChallenge(title: invite.challengeTitle, userId: userId, challengeId: invite.challengeId, durationDays: invite.durationDays, interval: invite.challengeInterval, description: invite.challengeDescription, userIds: [invite.challengedUserId, invite.challengerUserId], challengeCreator: invite.challengeCreater, challengedUserId: invite.challengedUserId, challengedUsername: invite.challengedUsername, challengerUserId: invite.challengerUserId, challengerUsername: invite.challengerUsername))
                
                //challenge for the other
                let Result = try db.collection("sharedActiveChallenges").addDocument(from: SharedActiveChallenge(title: invite.challengeTitle, userId: invite.challengerUserId, challengeId: invite.challengeId, durationDays: invite.durationDays, interval: invite.challengeInterval, description: invite.challengeDescription, userIds: [invite.challengedUserId, invite.challengerUserId], challengeCreator: invite.challengeCreater, challengedUserId: invite.challengedUserId, challengedUsername: invite.challengedUsername, challengerUserId: invite.challengerUserId, challengerUsername: invite.challengerUsername))
                   deleteInvite(invite)
            } catch {
                fatalError("Unable to encode challenge: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteInvite(_ invite: Invite) {
        db.collection("invites").document(invite.id ?? "").delete()
    }
    
    func deleteSharedChallengeInviteFrom (challengeId: String) {
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(myUserId).updateData([
            "pendingSharedChallengeInvite.\(challengeId)": FieldValue.delete()])
        db.collection("challenges").document(challengeId).updateData(["invitedSharedUserIds" : FieldValue.arrayRemove(["\(myUserId)"])])
    }
    
    func updateChallenge(_ challenge: ActiveChallenge) {
        if let challengeID = challenge.id {
            do {
                try db.collection("activeChallenges").document(challengeID).setData(from: challenge)
            } catch {
                fatalError("Unable to encode challenge: \(error.localizedDescription)")
            }
        }
    }
    func updateSharedChallenge(_ challenge: SharedActiveChallenge) {
        if let challengeID = challenge.id {
            do {
                try db.collection("sharedChallenges").document(challengeID).setData(from: challenge)
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
    func completeSharedChallenge(challenge: SharedActiveChallenge, username: String) {
        let group = DispatchGroup()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("users").document(userId)
        
        let challengeRef = db.collection("challenges").document(challenge.challengeId)
        userRef.getDocument { (document, error) in
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
                        let completedChallengeRef = self.db.collection("sharedCompletedChallenges").document(key)
                        completedChallengeRef.getDocument { (completedChallengeDocument, error) in
                            print("get completed Challenge by user")
                            if let completedChallengeDocument = completedChallengeDocument, completedChallengeDocument.exists {
                                let completedChallengedataDescription = completedChallengeDocument.data()
                                if completedChallengedataDescription?["challengeId"] != nil  && completedChallengedataDescription?["userId"] != nil {
                                    guard let completedChallengeId = completedChallengedataDescription?["challengeId"] as? String else {return}
                                    if completedChallengeId == challenge.challengeId {
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
                    print("non of the user completedChallenges is equal to \(challenge.challengeId), we create a new Completed Challenges Collection")
                        let newCompletedChallengesID = self.addNewCompletedSharedChallenge(challenge, userId: userId, username: username, timeInterval: Date().timeIntervalSince1970)
                        userRef.updateData(["completedChallenges.\(newCompletedChallengesID)": "\(challenge.challengeId)"])
                    challengeRef.updateData(["completedChallenges.\(newCompletedChallengesID)": "\(userId)"])
                    print("Completed Challenges Collection was created id: \(newCompletedChallengesID)")
                    }
            } else {
                
                
                print("user \(userId) has never completed a challenge")
                let newCompletedChallengesID = self.addNewCompletedSharedChallenge(challenge, userId: userId, username: username, timeInterval: Date().timeIntervalSince1970)
                userRef.updateData(["completedChallenges.\(newCompletedChallengesID)": challenge.challengeId])
                challengeRef.updateData(["completedChallenges.\(newCompletedChallengesID)": userId])
                print("first Completed Challenges Collection was created id: \(newCompletedChallengesID)")
            
            }
        }
        
    }
}
    func completeAChallenge(challenge: ActiveChallenge, username: String) {
        let group = DispatchGroup()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("users").document(userId)
        
        let challengeRef = db.collection("challenges").document(challenge.challengeId)
        userRef.getDocument { (document, error) in
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
                                    if completedChallengeId == challenge.challengeId {
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
                    print("non of the user completedChallenges is equal to \(challenge.challengeId), we create a new Completed Challenges Collection")
                        let newCompletedChallengesID = self.addNewCompletedChallenge(challenge, userId: userId, username: username, timeInterval: Date().timeIntervalSince1970)
                        userRef.updateData(["completedChallenges.\(newCompletedChallengesID)": "\(challenge.challengeId)"])
                    challengeRef.updateData(["completedChallenges.\(newCompletedChallengesID)": "\(userId)"])
                    print("Completed Challenges Collection was created id: \(newCompletedChallengesID)")
                    }
            } else {
                print("user \(userId) has never completed a challenge")
                let newCompletedChallengesID = self.addNewCompletedChallenge(challenge, userId: userId, username: username, timeInterval: Date().timeIntervalSince1970)
                userRef.updateData(["sharedCompletedChallenges.\(newCompletedChallengesID)": challenge.challengeId])
                challengeRef.updateData(["sharedCompletedChallenges.\(newCompletedChallengesID)": userId])
                print("first Completed Challenges Collection was created id: \(newCompletedChallengesID)")
            
            }
        }
        
    }
}
    
    
    func addNewCompletedChallenge(_ challenge: ActiveChallenge, userId: String, username: String, timeInterval: Double) -> String {
        
        
        do {
            print("adding")
            
            let result = try self.db.collection("completedChallenges").addDocument(from: CompletedChallenge(challengeId: challenge.challengeId , userId: userId, username: username, completed: [timeInterval], timesCompleted: 1, firstCompleted: timeInterval, challengeDuration: challenge.durationDays))
            print(result.documentID)
            return result.documentID
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
        
    }
    func addNewCompletedSharedChallenge(_ challenge: SharedActiveChallenge, userId: String, username: String, timeInterval: Double) -> String {
        
        var sharedWithId = ""
        do {
            print("adding")
            if (challenge.challengedUserId == userId) {
                sharedWithId = challenge.challengerUserId
            } else {
                sharedWithId = challenge.challengedUserId
            }
            let result = try self.db.collection("sharedCompletedChallenges").addDocument(from: SharedCompletedChallenge(challengeId: challenge.challengeId, userId: userId, completed: [timeInterval], timesCompleted: 1, firstCompleted: timeInterval, challengeDuration: challenge.durationDays, sharedChallengeId: challenge.id ?? "", sharedWithId: sharedWithId, username: username))
            print(result.documentID)
            return result.documentID
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
        
    }


    func followUser (userIdToFollow: String, usernameToFollow: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).updateData(["following":FieldValue.arrayUnion(["\(userIdToFollow)"])
        ])
        db.collection("users").document(userIdToFollow).updateData(["followers":FieldValue.arrayUnion(["\(userId)"])
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

