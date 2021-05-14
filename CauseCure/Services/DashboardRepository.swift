//
//  DashboardRepository.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 07.05.21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class DashboardRepository: ObservableObject {
    
    static var storeRoot = Firestore.firestore()
    
    static var Challenges = AuthService.storeRoot.collection("challenges")
    
    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    
    static func Challenges(challengeId: String) -> DocumentReference {
        return Challenges.document(challengeId)
    }
    
    let db = Firestore.firestore()
    @Published var dashboard = [Dashboard]()
    @Published var userChallenges = [Challenge]()
    @Published var userChallengeInvites = [Challenge]()
    @Published var userSharedChallengeInvites = [Challenge]()
    @Published var userSharedChallenges = [Challenge]()
    typealias finished = () -> ()
    

    
    init() {
//        createDashboardForUser()
        createDashboardForUser()
        
        loadDashboard()
        
//        print(dashboard.userId)
//        loadActiveUserChallenges()
    }
    // Needs TEST
    //Loading the users Dashboard as first entry of the Dashboard Array
    private func loadDashboard() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print(userId)
        db.collection("dashboards").whereField("userId", isEqualTo: userId)
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                print("in dashboards")
              self.dashboard = querySnapshot.documents.compactMap { document -> Dashboard? in
                try? document.data(as: Dashboard.self)
              }
            }
        }
    }

    
    
    func createDashboardForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            print("adding")
            let result = try db.collection("dashboards").addDocument(from: Dashboard(id: userId, userId: userId, activeChallenges: ["8HAy7GjEPRX27WZ53QBp"]))
            print(result.documentID)
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
    }
    
    // Create Challenge
    // WORKS
    func addChallenge(_ challenge: Challenge) {
        do {
            print("adding")
            let result = try db.collection("challenges").addDocument(from: challenge)
            print(result.documentID)
            updateCategory(challengeId: result.documentID, challengeName: challenge.title, category: challenge.category)
            addActiveChallengeToUser(challengeId: result.documentID)
        } catch {
            fatalError("Unable to encode challenge: \(error.localizedDescription)")
        }
    }
    func updateCategory(challengeId: String, challengeName: String, category: String) {
            db.collection("challengecategories").document(category).updateData([
                "challenges.\(challengeId)": challengeName
            ])
    }
    
    // Add challenge to user
    // Needs TEST
    func addActiveChallengeToUser(challengeId: String) {
        if dashboard != nil {
        print("dashboard")
        
        guard let dashboardId = dashboard[0].id else { return }
        print(dashboardId)
        db.collection("dashboards").document(dashboardId).updateData([
            "activeChallenges.\(challengeId)": ""
        ])
        }
        else {
            print("dashboard nil")
        }
        
    }
    // Remove active challenge from user dashboard
    // Needs TEST
    func removeActiveChallengefromUser(_ challenge: Challenge) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("dashboards").document(userId).updateData(["activeChallenges" : FieldValue.arrayRemove(["\(challenge.id)"])])
    }
    
    func addInvite(_ invite: Invite) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
    
        db.collection("dashboards").document(userId).updateData([
            "invites.\(invite)": ""
        ])
    }
    
    //NOT SURE
    func deleteChallengeInviteFrom (inviteId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("dashboards").document(userId).updateData([
            "invites.\(inviteId)": FieldValue.delete()])
    }
    
    
}
