//
//  Chat.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var repository = Repository()
    @ObservedObject var userListVM = UserListViewModel()
//    @ObservedObject var messageListVM = MessageListViewModel()
    @State var isPresented = false
    //TODO:
    
    //1 user cell
    
    
    //2 search
    
    //3 
    
    var body: some View {
        VStack{
        NavigationView{
            ZStack{
                Color.white.edgesIgnoringSafeArea(.all)
            VStack (alignment: .leading) {
//                HStack{
//                        Text("Follower List")
//                }
                if session.session != nil {
                    if session.session!.following != nil {
                        List {
                            ForEach(userListVM.userCellViewModels.filter {
                                session.session!.following!.keys.contains($0.user.uid!)}) {
                                    userCellVM in
                                ZStack {
//                                NavigationLink(destination: ChatLogView(messageListVM: messageListVM, session: self.session)) {
//                                    EmptyView()
//                                }.opacity(0.0)
//                                .buttonStyle(PlainButtonStyle())
                                FriendCard(userCellVM: userCellVM)
                                     
                        
                                }
                            
                            }
                        }
                        
                    }
                }

            }
                
            }

            .navigationBarTitle(Text("Social"))
            .navigationBarItems(trailing:
                HStack {
                    Button(action:  {
                        withAnimation{
                            self.isPresented.toggle()
                        }
                        }) {
                            Image(systemName: "magnifyingglass")
                        
                    }.foregroundColor(Color.black)
                }
            )
        }.fullScreenCover(isPresented: $isPresented) { UserFullScreenSearchModalView(repository: repository)
        }
    }
     
}
}

struct UserFullScreenSearchModalView: View {
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var repository = Repository()
        @ObservedObject var userListVM = UserListViewModel()
        var body: some View {
            //TODO: add dismiss button
            VStack{
            HStack {
                Spacer()
                Image(systemName: "xmark").onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }.padding()
                
            }
                Text("Search for other Users").font(.title)
            UserSearch()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
            }
           Spacer()
            
        }
    }
//struct Chat_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(session: <#T##SessionStore#>)
//    }
//}
