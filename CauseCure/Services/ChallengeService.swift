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
