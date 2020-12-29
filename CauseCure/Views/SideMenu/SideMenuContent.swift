//
//  SideMenuContent.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 20.12.20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SideMenuContent: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sharedInt: SharedInt
    @State var isPresented = false
    func logOut() {
        session.logout()
        self.sharedInt.myInt = 0
    }
    
        var body: some View {
            NavigationView {
                List {
                    HStack{
                        Text("Experience")
                        Spacer()
                        Text("\(session.session?.experience ?? 0)")
                    }
                    Button(action: {
                        withAnimation{
                            self.isPresented.toggle()
                        }
                        }, label: {
                            Text("My Profile")
                        })
                    
                    Text("Logout").onTapGesture {
                        logOut()
                    }
                    .fullScreenCover(isPresented: $isPresented, content: FullScreenModalView.init)
                } .navigationBarItems(leading:
                                        HStack {
                                             if session.session?.profileImageUrl != nil {
                                                 WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                                                    .resizable().clipShape(Circle())
                                                    .frame(width: 30, height: 30)
                                                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                             } else {
                                                 Image(systemName: "person.fill").resizable()
                                                     .frame(width: 25, height: 25)
                                                     .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                             }
                                         }
                                        , trailing:
                                        //add further nav bar button
                                         HStack {
                                            Text("")
                                        })
           
                    //Modal
            }
            
        }
}
    
struct FullScreenModalView: View {
        @Environment(\.presentationMode) var presentationMode
        var body: some View {
            //TODO: add dismiss button
            MyProfile()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }


