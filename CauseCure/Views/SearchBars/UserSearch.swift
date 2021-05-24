//
//  UserSearch.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 25.12.20.
//

import SwiftUI

struct UserSearch: View {
        @ObservedObject var userSearch = UserSearchService()
        @ObservedObject var repository : Repository
        //    @Binding var challenges : [Challenge]
        @State var txt = ""
        @State private var showCancelButton: Bool = false
    
    func followUser(user: User) {
        self.repository.followUser(userIdToFollow: user.uid ?? "", usernameToFollow: user.username ?? "")
        }
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
           
            NavigationView{
//            Text("Results").font(.subheadline)
            List(self.userSearch.users.filter { $0.username.lowercased().contains(self.txt.lowercased())}) { i in
                VStack {
                    Button(action: {
                        self.followUser(user: i)
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                           
                        }
                    }.padding()
                }
                NavigationLink(destination: UserProfile(userCellVM: UserCellViewModel(user: i, repository: repository))) {
                                    Text(i.username)
                                    
                                }
                            }.frame(height: UIScreen.main.bounds.height / 5)
                
                        }
            .onDisappear(perform: userSearch.deleteUserSnapshots)
                    }
            }
            }

    

//
//struct UserSearch_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSearch()
//    }
//}
