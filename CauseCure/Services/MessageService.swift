//
//  MessageService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 20.01.21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: This service is currently under construction and will load all user Chats / Messages 
class MessageService: ObservableObject {
    
    @Published var message: [Message] = []
    
 
    func postSorting(first: PostModel, second: PostModel) -> Bool{
        print("sorting")
        return Date(timeIntervalSince1970: first.date) > Date(timeIntervalSince1970: second.date)
    }
    func loadUserChats(userId: String) {
//        guard let myId = Auth.auth().currentUser?.uid else { return }
//        let group = DispatchGroup()
//        group.enter()
//        var chatIds = [String]()
//
//        let userDocRef = Firestore.firestore().collection("users").document(myId)
//
//        userDocRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data()
//                if dataDescription?["chats"] != nil {
//                    let following = dataDescription!["chats"] as! Dictionary<String, String>
//                    for (key, _) in following {
//                        chatIds.append(key)
//                    }
//                }
//            }
//        var chatMessages : [PostModel] = []
//        for id in chatIds {
//            if (id == userId) {
//                let chatRef = Firestore.firestore().collection("chats").document(id)
//            }
//         }
//            group.leave()
//            group.notify(queue: DispatchQueue.main) {
//                self.followingPosts =  followingPosts.sorted (by: {Date(timeIntervalSince1970: $0.date) > Date(timeIntervalSince1970: $1.date)})
//            }
//        }
//    }
    }
}
