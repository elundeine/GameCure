//
//  UserProfileDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.12.20.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct UserProfileDetail: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var userModel = UserRepository()
    @State private var imageURL = URL(string: "")
    @EnvironmentObject var sharedInt: SharedInt
    
    func performOnAppear() {
        listen()
    }
    
    func listen() {
        session.listen()
    }
    
    func logOut() {
        session.logout()
        self.sharedInt.myInt = 0
    }
    
    var body: some View {
//        VStack {
//            VStack{
//                //TODO: Display PROFILE image here
//            }
//            Text("\(session.session?.username ?? "")") .font(.title)
//            Divider()
//            VStack(alignment: .leading) {
//                HStack(alignment: .top) {
//                    Text(session.session?.email ?? "")
//                }
//                HStack(alignment: .top) {
//                    Text("Bio")
//                        .font(.subheadline)
//                        .bold()
//                    Spacer()
//                }.padding()
//                    HStack{
//                        Text("\(session.session?.bio ?? "")")
//                        .font(.subheadline)
//                    }.padding()
//                HStack(alignment: .top) {
//                    Text("Challenges")
//                        .font(.subheadline)
//                        .bold()
//                }.padding()
//            }
//            Spacer()
//        }
        
        
        VStack {
            WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                      .resizable()
                      .aspectRatio(contentMode: .fit)

        Text(session.session?.email ?? "")
        VStack{
           Button(action: logOut) {
               Text("Log out").font(.title).modifier(ButtonModifier())
           }
        }
        }
            
            .onAppear(perform: performOnAppear)
        
    }
}

struct UserProfileDetail_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileDetail()
    }
}
