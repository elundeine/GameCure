//
//  ProfileService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 09.01.21.
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

// MARK: This service retrieves the Posts of Users the current User is following.

class ProfileService: ObservableObject {
    
    @Published var posts: [PostModel] = []
    @Published var followingPosts: [PostModel] = []
    
    func loadUserPosts(userId: String) {
        PostService.loadPostsCreatedByUser(userId: userId) {
            (posts) in
            
            self.posts = posts
        }
    }
    func postSorting(first: PostModel, second: PostModel) -> Bool{
        print("sorting")
        return Date(timeIntervalSince1970: first.date) > Date(timeIntervalSince1970: second.date)
    }
    func loadFollowingPosts(userId: String) {
        let group = DispatchGroup()
        group.enter()
        var followingIds = [String]()
       
        let userDocRef = Firestore.firestore().collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                if dataDescription?["following"] != nil {
                    let following = dataDescription!["following"] as! Array<String>
                    for followingId in following {
                        followingIds.append(followingId)
                    }
                }
            }
        var followingPosts : [PostModel] = []
        for id in followingIds {
            PostService.loadPostsCreatedByUser(userId: id) {
                (posts) in
                followingPosts.append(contentsOf: posts)
                self.followingPosts = followingPosts
            }
         }
            group.leave()
            group.notify(queue: DispatchQueue.main) {
                self.followingPosts =  followingPosts.sorted (by: {Date(timeIntervalSince1970: $0.date) > Date(timeIntervalSince1970: $1.date)})
            }
        }
    }
    
}
