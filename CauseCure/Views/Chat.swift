//
//  Chat.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var repository = Repository()
    @State var isPresented = false
    //TODO:
    
    //1 user cell
    
    
    //2 search
    
    //3 
    
    var body: some View {
        VStack{
        NavigationView{
            VStack {
                
            
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
                Text("Dismiss").onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }.padding()
                
            }
            UserSearch(repository: repository)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
            }
           Spacer()
            
        }
    }
struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
