//
//  Community.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI
import FirebaseAuth
struct Community: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var profileService = ProfileService()
    @State var isPresented = false
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                ScrollView{
                    VStack{
                        ForEach(self.profileService.followingPosts.sorted(by: {$0.date > $1.date}), id:\.postId) {
                            (post) in
                            
                            PostCardImage(post: post)
                            PostCard(post: post)
                        }
                    }
                }
                .onAppear{
                    self.profileService.loadFollowingPosts(userId: Auth.auth().currentUser!.uid)
                }
            }
            .navigationBarTitle("Explore")
            .navigationBarItems(leading: HStack{
                Button(action:  {
                    withAnimation{
                        self.profileService.loadFollowingPosts(userId: Auth.auth().currentUser!.uid)
                    }
                }) {
                    Image(systemName: "arrow.clockwise.icloud.fill")
                    
                }.foregroundColor(Color.black)
            } ,
                                trailing:
                                    HStack {
                                        Button(action:  {
                                            withAnimation{
                                                self.isPresented.toggle()
                                            }
                                        }) {
                                            Image(systemName: "plus")
                                            
                                        }.foregroundColor(Color.black)
                                    }
            )
        }.fullScreenCover(isPresented: $isPresented) { PostFullScreenModalView()
        }
    }
}
    struct PostFullScreenModalView: View {
            @Environment(\.presentationMode) var presentationMode
            var body: some View {
                //TODO: add dismiss button
                VStack{
                HStack {
                    Spacer()
                    Text("Dismiss").onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                    
                }
                
                Post()
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                }
                Spacer()
                
            }
        }

//
//struct Community_Previews: PreviewProvider {
//    static var previews: some View {
//        Community()
//    }
//}
////{
//
//    VStack(alignment: .leading, spacing: 15){
//        HStack(){
//            Text("Publications")
//                .fontWeight(.semibold)
//            Spacer()
//            Text("100")
//                .fontWeight(.semibold)
//        }
//        HStack(){
//            Text("Followers")
//                .fontWeight(.semibold)
//            Spacer()
//            Text("56")
//                .fontWeight(.semibold)
//        }
//        HStack(){
//            Text("Experience")
//                .fontWeight(.semibold)
//            Spacer()
//            Text("195320")
//                .fontWeight(.semibold)
//        }
//        HStack(){
//            Text("Points")
//                .fontWeight(.semibold)
//            Spacer()
//            Text("1984 Stone Coins")
//                .fontWeight(.semibold)
//        }
//    }.padding(EdgeInsets(top:10, leading:10, bottom:10, trailing: 10))
//}
