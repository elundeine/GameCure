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
        ZStack { 
                VStack (alignment: .leading){
                HStack{
                    VStack{
                        WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                        .resizable()
                        
                        Text("Your Name")
                            .fontWeight(.semibold)
                    }
                }
            
                VStack {
                    Picker(selection: $selectedTab,label: Text("")) {
                                Text("Description").tag(0)
                                Text("Stats").tag(1)
                                Text("Followers").tag(2)
                            }.pickerStyle(SegmentedPickerStyle())

                            switch(selectedTab) {
                                case 0: Community()
                                case 1: ChatView()
                                case 2: Community()
                                default: Community()

                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 15){
                        HStack(){
                            Text("Description")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("I am a very cool Person!")
                                .fontWeight(.semibold)
                        }
                        HStack(){
                            Text("Age")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("25")
                                .fontWeight(.semibold)
                        }
                        HStack(){
                            Text("Number of Stones")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("12")
                                .fontWeight(.semibold)
                        }
                        HStack(){
                            Text("Biggest Stone")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("3mm")
                                .fontWeight(.semibold)
                        }
                        HStack(){
                            Text("Status")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("IN PAIN!")
                                .fontWeight(.semibold)
                        }
                        
                        
                    }.padding(EdgeInsets(top:0, leading:10, bottom:20, trailing: 10))
                    
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
