//
//  StorageService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestoreSwift


// MARK: The StorageService handles all Data which needs to be stored in the Firebase Storage:
//  -Profile Images
//  -Post Images

class StorageService {
    
    static var storage = Storage.storage()
    
    static var storageRoot = storage.reference(forURL: "gs://gamecure-81680.appspot.com")
    
    static var storageProfile = storageRoot.child("profile")
    
    static var storagePost = storageRoot.child("posts")
    
    static var storageChat = storageRoot.child("chat")
    
    static func storageProfileId(userId: String) -> StorageReference {
        return storageProfile.child(userId)
    }
    
    static func storagePostId(postId: String) -> StorageReference {
        return storagePost.child(postId)
    }
    
    static func storageChatId(chatId: String) -> StorageReference {
        return storageChat.child(chatId)
    }
    
    static func updateProfileImage(userId: String, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String)-> Void) {
        
        storageProfileImageRef.delete()
        
        storageProfileImageRef.putData(imageData, metadata: metaData) {
            (StorageMetadata, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            /*
            storageProfileImageRef.downloadURL {
                (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges {
                            (error) in
                            if error != nil {
                                onError(error!.localizedDescription)
                                return
                            }
                        }
                    }
                    
                    let firestoreUserId = AuthService.getUserId(userId: userId)
                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, experience: 0, searchName: username.splitStringtoArray(), bio: "", loggedInDates: [""], completedTour: false)
                     
                    guard let dict = try?user.asDictionary() else { return }
                    
                    firestoreUserId.setData(dict) {
                        (error) in
                        if error != nil {
                            onError(error!.localizedDescription)
                        }
                    }
                    
                    onSuccess(user)
                }
            }
             */
        }
    }
    
    static func saveProfileImage(userId: String, username: String, email: String, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String)-> Void) {
        
        storageProfileImageRef.putData(imageData, metadata: metaData) {
            (StorageMetadata, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            storageProfileImageRef.downloadURL {
                (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges {
                            (error) in
                            if error != nil {
                                onError(error!.localizedDescription)
                                return
                            }
                        }
                    }
                    
                    let firestoreUserId = AuthService.getUserId(userId: userId)
                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, experience: 0, searchName: username.splitStringtoArray(), bio: "", loggedInDates: [""], completedTour: false)
                     
                    guard let dict = try?user.asDictionary() else { return }
                    
                    firestoreUserId.setData(dict) {
                        (error) in
                        if error != nil {
                            onError(error!.localizedDescription)
                        }
                    }
                    
                    onSuccess(user)
                }
            }
        }
        
    }
    
    static func savePostPhoto(userId: String, caption: String, postId: String, imageData: Data, metaData: StorageMetadata, storagePostRef: StorageReference, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String)-> Void) {
        
        
            storagePostRef.putData(imageData, metadata: metaData) {
            (StorageMetadata, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
                
            storagePostRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    let firestorePostRef = PostService.PostsUserId(userId: userId).collection("posts").document(postId)
                    
                    let post = PostModel.init(caption: caption, likes: [:], geoLocation: "", ownerId: userId, postId: postId, username: Auth.auth().currentUser!.displayName!, profile: Auth.auth().currentUser!.photoURL!.absoluteString, mediaUrl: metaImageUrl, date: Date().timeIntervalSince1970, likeCount: 0)
                    
                    
                    guard let dict = try? post.asDictionary() else {return}
                    
                    firestorePostRef.setData(dict) {
                        (error) in
                        if error != nil {
                            onError(error!.localizedDescription)
                            return
                        }
                        PostService.timelineUserId(userId: userId).collection("timeline").document(postId).setData(dict)
                        PostService.AllPosts.document(postId).setData(dict)
                        onSuccess()
                    }
                    
                }
                }
                        
        }
    }
    
    static func saveChatPhoto(messageId: String, recipientId: String, recipientProfile: String, recipientName: String, senderProfile: String, senderId: String, senderUsername: String, imageData: Data, metadata: StorageMetadata, storageChatRef: StorageReference, onSuccess: @escaping() -> Void, onError: @escaping(_ error: String)-> Void) {
        
        
        storageChatRef.putData(imageData, metadata: metadata) {
            (StorageMetadata, err) in
            
            if(err != nil) {
                onError(err!.localizedDescription)
                
                return
            }
            storageChatRef.downloadURL {
                (url, error) in
                
                if let metaImageUrl = url?.absoluteString {
                    let chat = Chat(messageId: messageId, textMessage: "", profile: senderProfile, photoUrl: metaImageUrl, sender: senderId, username: senderUsername, timestamp: Date().timeIntervalSince1970, isPhoto: true)
                    
                    guard let dict = try? chat.asDictionary() else {return}
                    
                    ChatService.conversation(sender: senderId, recipient: recipientId).document(messageId).setData(dict) {
                        (error) in
                        
                        if error == nil {
                            ChatService.conversation(sender: recipientId, recipient: senderId).document(messageId).setData(dict)
                            
                            let senderMessage = Message(lastMessage: "", username: senderUsername, isPhoto: true, timestamp: Date().timeIntervalSince1970, userID: senderId, profile: senderProfile)
                            let recipientMessage = Message(lastMessage: "", username: recipientName, isPhoto: true, timestamp: Date().timeIntervalSince1970, userID: recipientId, profile: recipientProfile)
                            
                            guard let senderDict = try? senderMessage.asDictionary() else {return}
                            
                            guard let recipientDict = try? recipientMessage.asDictionary() else {return}
                            
                            ChatService.messagesId(senderId: senderId, recipientId: recipientId).setData(recipientDict)
                            ChatService.messagesId(senderId: recipientId, recipientId: senderId).setData(senderDict)
                            
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    }
                }
            }
        }
        
        
    }
}
