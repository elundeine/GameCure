//
//  Chat.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var repository : Repository
 
    @StateObject var followerListVM: FollowerListViewModel
//    @ObservedObject var messageListVM = MessageListViewModel()
    @State var isPresented = false
    //TODO:
    
    //1 user cell
    
    
    //2 search
    
    //3
    
    init(session: SessionStore, repository: Repository) {
        self.session = session
        self.repository = repository
      
        _followerListVM = StateObject(wrappedValue: FollowerListViewModel(repository: repository))
    }
    var body: some View {
        VStack{
        NavigationView{
            ZStack{
                Color.white.edgesIgnoringSafeArea(.all)
            VStack (alignment: .leading) {
//                HStack{
//                        Text("Follower List")
//                }
                  List {
                    ForEach (followerListVM.followerCellViewModels) { followerCellVM in
                                ZStack {
//                                NavigationLink(destination: ChatLogView(messageListVM: messageListVM, session: self.session)) {
//                                    EmptyView()
//                                }.opacity(0.0)
//                                .buttonStyle(PlainButtonStyle())
                                FriendCard(userCellVM: followerCellVM)
                                     
                        
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
struct UserFullScreenSearchModalView: View {
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var repository : Repository
        @StateObject var userListVM : UserListViewModel
    
    init(repository: Repository) {
        self.repository = repository
        _userListVM = StateObject(wrappedValue: UserListViewModel(repository: repository))
    }
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
                UserSearch(repository: repository)
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
}
