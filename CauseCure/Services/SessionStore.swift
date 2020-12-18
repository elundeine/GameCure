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

class SessionStore: ObservableObject {
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {
        didSet{
            self.didChange.send(self)
        }}
    
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()

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
