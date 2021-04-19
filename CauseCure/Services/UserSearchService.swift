//
//  UserSearchService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 19.04.21.
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


class UserSearchService: ObservableObject {
    

    static var storeRoot = Firestore.firestore()
    
    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    let db = Firestore.firestore()

    @Published var users = [User]()
    typealias finished = () -> ()
    
    init() {
        loadUsers()
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

}
