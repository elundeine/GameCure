//
//  ChatService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 27.12.20.
//

import Foundation
import Firebase
// MARK: This service is currently under construction and will load all user Chats / Messages 
class ChatService: ObservableObject {

    @Published var isLoading = false
    @Published var chats: [Chat] = []
    
    var listener: ListenerRegistration!
    var recipientId = ""
    
    static var chats = AuthService.storeRoot.collection("chats")
    static var messages = AuthService.storeRoot.collection("messages")
    
    static func conversation(sender: String, recipient: String) -> CollectionReference {
        return chats.document(sender).collection("chats").document(recipient).collection("conversation")
    }
    
    static func userMesages(userid: String) -> CollectionReference {
        return messages.document(userid).collection("messages")
    }
    
    static func messagesId(senderId: String, recipientId: String) -> DocumentReference {
        return messages.document(senderId).collection("messages").document(recipientId)
    }
    
    func loadChats() {
        self.chats = []
        self.isLoading = true
        
        self.getChats(userId: recipientId, onSuccess: {
            (chats) in
            
            if self.chats.isEmpty {
                self.chats = chats
            }
        }, onError: {
            (err) in
            print("Error \(err)")
        }, newChat: {
            (chat) in
            if self.chats.isEmpty {
                self.chats.append(chat)
            }
        }){
            (listener) in
            self.listener = listener
        }
    }
    
    func sendMessage(message: String, recipientId: String, recipientProfile: String, recipientName: String, onSuccess: @escaping() -> Void, onError: @escaping(_ error: String)-> Void) {
        
        guard let senderId = Auth.auth().currentUser?.uid else {return}
        
        guard let senderUsername = Auth.auth().currentUser?.displayName else {return }
        
        guard let senderProfile = Auth.auth().currentUser?.photoURL!.absoluteString else { return }
        
        let messageId = ChatService.conversation(sender: senderId, recipient: recipientId).document().documentID
    
        let chat = Chat(messageId: messageId, textMessage: message, profile: senderProfile, photoUrl: "", sender: senderId, username: senderUsername, timestamp: Date().timeIntervalSince1970, isPhoto: false)
        
        guard let dict = try? chat.asDictionary() else {return}
            
            ChatService.conversation(sender: senderId, recipient: recipientId).document(messageId).setData(dict) {
                (error) in
                
                if error == nil {
                    ChatService.conversation(sender: recipientId, recipient: senderId).document(messageId).setData(dict)
                    
                    let senderMessage = Message(lastMessage: message, username: senderUsername, isPhoto: false, timestamp: Date().timeIntervalSince1970, userID: senderId, profile: senderProfile)
                    let recipientMessage = Message(lastMessage: message, username: recipientName, isPhoto: false, timestamp: Date().timeIntervalSince1970, userID: recipientId, profile: recipientProfile)
                    
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
    
    func sendPhotoMessage(imageData: Data, recipientId: String, recipientProfile: String, recipientName: String, onSuccess: @escaping() -> Void, onError: @escaping(_ error: String)-> Void) {
        
        guard let senderId = Auth.auth().currentUser?.uid else {return}
        
        guard let senderUsername = Auth.auth().currentUser?.displayName else {return }
        
        guard let senderProfile = Auth.auth().currentUser?.photoURL!.absoluteString else { return }
        
        let messageId = ChatService.conversation(sender: senderId, recipient: recipientId).document().documentID
    
        let storageChatRef = StorageService.storageChatId(chatId: messageId)
        
        let metadata = StorageMetadata()
        
        metadata.contentType = "image/jpg"
        
        StorageService.saveChatPhoto(messageId: messageId, recipientId: recipientId, recipientProfile: recipientProfile, recipientName: recipientName, senderProfile: senderProfile, senderId: senderId, senderUsername: senderUsername, imageData: imageData, metadata: metadata, storageChatRef: storageChatRef, onSuccess: onSuccess, onError: onError)
        
    }
    
    func getChats(userId: String, onSuccess: @escaping([Chat])-> Void, onError: @escaping(_ error: String)-> Void, newChat: @escaping(Chat)-> Void, listener: @escaping(_ listenerHandle: ListenerRegistration)-> Void) {
        
        let listenerChat = ChatService.conversation(sender: Auth.auth().currentUser!.uid, recipient: userId).order(by: "timestamp", descending: false).addSnapshotListener {
            (qs, err) in
            guard let snapshot = qs else {
                return
            }
            var chats = [Chat]()
            
            snapshot.documentChanges.forEach {
                (diff) in
                
                if (diff.type == .added) {
                    let dict = diff.document.data()
                    
                    guard let decoded = try? Chat.init(fromDictionary: dict) else { return }
                    newChat(decoded)
                    chats.append(decoded)
                }
                if(diff.type == .modified) {
                    print("modified")
                }
                if(diff.type == .removed) {
                    print("removed")
                }
            }
            onSuccess(chats)
        }
        listener(listenerChat)
        
    }
    
    func getMessages(onSuccess: @escaping([Message])-> Void, onError: @escaping(_ error: String)-> Void, newMessage: @escaping(Message)-> Void, listener: @escaping(_ listenerHandle: ListenerRegistration)-> Void) {
        let listenerMessage = ChatService.userMesages(userid: Auth.auth().currentUser!.uid).order(by: "timestamp", descending: true).addSnapshotListener {
            (qs, err) in
            guard let snapshot = qs else {
                return
            }
            var messages = [Message]()
            
            snapshot.documentChanges.forEach {
                (diff) in
                
                if (diff.type == .added) {
                    let dict = diff.document.data()
                    
                    guard let decoded = try? Message.init(fromDictionary: dict) else { return }
                    newMessage(decoded)
                    messages.append(decoded)
                }
                if(diff.type == .modified) {
                    print("modified")
                }
                if(diff.type == .removed) {
                    print("removed")
                }
            }
            onSuccess(messages)
        }
        listener(listenerMessage)
    }
}
