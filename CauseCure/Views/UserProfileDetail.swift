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
    @State private var imageURL = URL(string: "")
    @EnvironmentObject var sharedInt: SharedInt
    
    @State private var selectedTab: Int = 0
    
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
        GeometryReader { geometry in
            VStack (alignment: .leading){
                HStack{
                    Spacer()
                    Button(action: {}){
                                            Image(systemName: "square.and.arrow.up")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                    }
                }.padding()
            HStack{
                VStack{
                    WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                    .resizable()
                    .frame(width: 90, height: 90)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .overlay(Circle().stroke(Color.pink, lineWidth: 1))
                    
                    Text("Your Name")
                        .fontWeight(.semibold)
                }.padding(.leading, 10)
                
                VStack{
                    Text("10")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    
                    Text("Publications")
                    .font(.system(size: 13))
                }.padding(.leading, 30)
                
                VStack{
                    Text("100")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    
                    Text("Followers")
                    .font(.system(size: 13))
                }.padding()
                
                VStack{
                    Text("1000")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    
                    Text("Following")
                    .font(.system(size: 13))
                }
                
            }.frame(height: 100)
            .padding(.leading, 10)
        
            VStack {
                Picker(selection: $selectedTab,label: Text("")) {
                            Text("First").tag(0)
                            Text("Second").tag(1)
                            Text("Third").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())

                        switch(selectedTab) {
                            case 0: Community()
                            case 1: Chat()
                            case 2: Community()
                            default: Community()

                        }
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