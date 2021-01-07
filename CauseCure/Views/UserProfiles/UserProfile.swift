//
//  UserProfile.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 25.12.20.
//

import SwiftUI
import SDWebImageSwiftUI


struct UserProfile: View {
    @State private var imageURL = URL(string: "")
    @State private var selectedTab: Int = 0
    @ObservedObject var userCellVM: UserCellViewModel
    
    func followUser() {
        userCellVM.repository.followUser(userIdToFollow: userCellVM.user.uid ?? "", usernameToFollow: userCellVM.user.username ?? "")
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
                    WebImage(url: URL(string: userCellVM.user.profileImageUrl ?? ""))
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
                            case 0: Stats()
                            case 1: Stats()
                            case 2: Stats()
                            default: Stats()

                    }
            }
                VStack {
                    Button(action: {
                        self.followUser()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Follow")
                        }
                    }.padding()
                }
        }
        
        }
       
    }
    
}


//struct UserProfile_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfile()
//    }
//}
