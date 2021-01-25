//
//  SessionStore.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: This service sets up a logged in Session which allows the user to skip the login process when reopening the CauseCure app.

class SessionStore: ObservableObject {
    
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {
        didSet{
            self.didChange.send(self)
        }}
    @Published var messages = [Message]()
    @Published var messagesDictionary = [String:Message]()
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()

    func addDescriptionStats(description: DescriptionModel, stats: StatsModel){
        guard let descdic = try? description.asDictionary() else { return }
        guard let statsdic = try? stats.asDictionary() else { return }
        db.collection("users").document(session!.uid!).updateData(["description": descdic, "stats": statsdic])
    }


    func listen() {
        handle = Auth.auth().addStateDidChangeListener({
            (auth, user) in
            
            if let user = user {
               
                let firestoreUserId = AuthService.getUserId(userId: user.uid)
                firestoreUserId.getDocument {
                    (document, error) in
                    if let dict = document?.data() {
                        guard let decodedUser = try? User.init(fromDictionary: dict) else { return }
                        self.session = decodedUser
                    }
                }
               
                
            } else {
                print("session store nil")
                self.session = nil
            }
        })
    }
    
//    func buyStoneCrusherGame(userId: String, experience: Int) -> Bool {
//        
//        if (experience >= 50) {
//            db.collection("users").document(userId).updateData([
//            "experience.\(experience - 50)": ""
//        ])
//            return true
//        } else {
//            return false
//        }
//    }
    func payforStoneCrusherGame(userId: String, experience: Int) {
        
        db.collection("users").document(userId).updateData([
            "experience.\(experience - 50)": ""])
    }
    
    func logout() {
        do{
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    //TODO: FIX hacky array implementation, at the moment array contains on user, the current user

//
//    func getCurrentUserProfileImageURL() -> String {
//        guard let returnURL = users[0].profileImageUrl as String? else { return "" }
//        return returnURL
//    }
    
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeIDTokenDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}
