//
//  ProfileService.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 09.01.21.
//

import Foundation


class ProfileService: ObservableObject {
    
    @Published var posts: [PostModel] = []
    
    func loadUserPosts(userId: String) {
        PostService.loadPostsCreatedByUser(userId: userId) {
            (posts) in
            
            self.posts = posts
        }
    }
}
