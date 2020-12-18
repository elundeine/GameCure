//
//  UserRepository.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.12.20.
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

let db = Firestore.firestore()
@Published var users = [User]()

init() {
    loadData()
}
    
    

    private func loadData() {
        db.collection("challenges")
            .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
              print("in querySnapshot")
              self.users = querySnapshot.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
              }
            }
      }
    }
    
    
}
