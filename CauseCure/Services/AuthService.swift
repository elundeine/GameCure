//
//  AuthService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

// MARK: Setup Service of Firebase User Authentication
class AuthService {
    
    static var storeRoot = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid ?? "uid"
    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String)-> Void) {
     
        Auth.auth().createUser(withEmail: email, password: password) {
            (authData, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            guard let userId = authData?.user.uid else { return }
            
            let storageProfileUserId = StorageService.storageProfileId(userId: userId)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            StorageService.saveProfileImage(userId: userId, username: username, email: email, imageData: imageData, metaData: metadata, storageProfileImageRef: storageProfileUserId, onSuccess: onSuccess, onError: onError)
            
        }
        
    }
    
    func signInn(email:String,password:String,handler : @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    static func signIn(email: String, password: String, onSuccess: @escaping(_ user: User) -> Void,onError: @escaping(_ errorMessage: String)-> Void) {
    
        Auth.auth().signIn(withEmail: email, password: password) {
            (authData, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            guard let userId = authData?.user.uid else { return }
            
            let firestoreUserId = getUserId(userId: userId)
            firestoreUserId.getDocument{
                (document, error) in
                if let dict = document?.data() {
                    guard let decodedUser = try? User.init(fromDictionary: dict) else {return}
                    
                    onSuccess(decodedUser)
                }
            }
            
        }
    }
}
