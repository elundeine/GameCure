//
//  UserSearch.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 25.12.20.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserSearch: View {
        @ObservedObject var userSearch = UserSearchService()
        @ObservedObject var repository : Repository
        //    @Binding var challenges : [Challenge]
        @State var txt = ""
        @State private var showCancelButton: Bool = false
    
        
    
    var body: some View {
        VStack{
            VStack {
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("search", text: $txt, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        print("onCommit")
                    }).foregroundColor(.primary)
                    
                    Button(action: {
                        self.txt = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(txt == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                if showCancelButton  {
                    Button("Cancel") {
                        // this must be placed before the other commands here
                        self.txt = ""
                        self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(showCancelButton)
            
            
                //            Text("Results").font(.subheadline)
                List(self.userSearch.users.filter { $0.username.lowercased().contains(self.txt.lowercased())}) { i in
                    UserSearchCard(userCellVM: UserCellViewModel(user: i, repository: repository), repository: repository)
                    
                }.frame(height: UIScreen.main.bounds.height / 5)
                
            
            .onDisappear(perform: userSearch.deleteUserSnapshots)
            Spacer()
        }
    }
}

    

struct UserSearchCard: View {
    @ObservedObject var userCellVM: UserCellViewModel
    @ObservedObject var repository : Repository
    func followUser(user: User) {
        self.repository.followUser(userIdToFollow: user.uid ?? "", usernameToFollow: user.username ?? "")
    }
    var body: some View {
        HStack(alignment: .center) {
        WebImage(url: URL(string: userCellVM.user.profileImageUrl))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: 120)
            .padding(.all, 20)
        
        VStack(alignment: .leading) {
                Text("\(userCellVM.user.username)")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
//                HStack {
//                    Text("daily")
//                    .font(.system(size: 16, weight: .bold, design: .default))
//                    .foregroundColor(.white)
//                    .padding(.top, 8)
//                }
        }.padding(.trailing, 20)
            Spacer()
            VStack {
                Button(action: {
                    self.followUser(user: userCellVM.user)
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                        
                    }
                }.padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}
