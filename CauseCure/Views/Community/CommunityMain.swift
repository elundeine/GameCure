//
//  CommunityMain.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 09.01.21.
//

import SwiftUI
import FirebaseAuth
struct CommunityMain: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var profileService = ProfileService()
    var body: some View {
        ScrollView{
            VStack{
                ForEach(self.profileService.posts, id:\.postId) {
                    (post) in
                    
                    PostCardImage(post: post)
                    PostCard(post: post)
                }
            }
        }
        .onAppear{
            self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
        }
    }
}

struct CommunityMain_Previews: PreviewProvider {
    static var previews: some View {
        CommunityMain()
    }
}
