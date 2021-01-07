//
//  UserPostsService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 04.01.21.
//

import Foundation

class ProfileService: ObservableObject {
    @Published var posts: [PostModel] = []
    
    func loadUserPosts(userId: String) {
        PostService.loadPostsCreatedByCurrentUser(userId:userId) {
            (posts) in
            
            self.posts = posts
        }
    }
}
