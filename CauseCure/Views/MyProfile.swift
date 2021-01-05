//
//  UserProfileDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.12.20.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct MyProfile: View {
    @EnvironmentObject var session: SessionStore
    @State private var imageURL = URL(string: "")
    
    
    @State private var selectedTab: Int = 0
    
    @State var presentationMode = true
    
    func performOnAppear() {
        listen()
    }
    
    func listen() {
        session.listen()
    }
    
    func logOut() {
        session.logout()
    }
    
    var body: some View {
        GeometryReader { geometry in
                VStack (alignment: .leading){
                    HStack {
                        VStack {
                            HStack{
                                    WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                                    .resizable()
                                        .frame(width: 100, height: 100)
                            }.clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 5))
                            
                            HStack{
                                Text(session.session!.username)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                            }
                        }.padding(20)
                        VStack{
                            Text("Level 100")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                        }
                    }
                VStack {
                    Picker(selection: $selectedTab,label: Text("")) {
                                Text("Description").tag(0)
                                Text("Stats").tag(1)
                                Text("Community").tag(2)
                            }.pickerStyle(SegmentedPickerStyle())

                            switch(selectedTab) {
                                case 0: Description()
                                case 1: Stats()
                                case 2: Community()
                                default: Description()

                            }
                        }
                    
                }
        
        }
        .onAppear(perform: performOnAppear)
    }
    
}
    

struct UserProfileDetail_Previews: PreviewProvider {
    static var previews: some View {
        MyProfile()
    }
}
