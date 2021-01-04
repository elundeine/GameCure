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
    @State var isPresented = false
    func logOut() {
        session.logout()
    }
    
        var body: some View {
            NavigationView {
                List {
                    Button(action: {
                        withAnimation{
                            self.isPresented.toggle()
                        }
                        }, label: {
                            Text("My Profile")
                        })
                    HStack{
                        Text("Experience")
                        Spacer()
                        Text("\(session.session?.experience ?? 0)")
                        }
                    
                    Text("Posts").onTapGesture {
                        print("Posts")
                    }
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
            ZStack {
            //TODO: add dismiss button
            MyProfile()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading){
                    HStack{
                        Text("Level 100")
                            .font(.system(size: 20))
                            .padding(10)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.black, lineWidth: 5)
                            ).background(Capsule().fill(Color.white))
                        Spacer()
                        Text("Dismiss").onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.system(size: 20))
                        .padding(10)
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.black, lineWidth: 5)
                        ).background(Capsule().fill(Color.white))
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Your Name")
                            .fontWeight(.semibold)
                            .font(.system(size: 40))
                            .padding(15)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.black, lineWidth: 7)
                            ).background(Capsule().fill(Color.white))
                        Spacer()
                    }
                    Spacer()
                    Spacer()
                }
            
                
            }
        }
    }


