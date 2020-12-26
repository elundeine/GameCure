//
//  UserRepository.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 25.12.20.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import SwiftUI

class UserRepository: ObservableObject {
    
    @EnvironmentObject var session: SessionStore
    static var storeRoot = Firestore.firestore()

    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    
    let db = Firestore.firestore()
    
    @Published var users = [User]()

init() {
    loadUsers()
    print(self.users)
}

    private func loadUsers() {
        print("before db collection")
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            print("loading user")
            if let querySnapshot = querySnapshot {
                
                  print("in querySnapshot of users")
              self.users = querySnapshot.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
              }
            }
        }
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
