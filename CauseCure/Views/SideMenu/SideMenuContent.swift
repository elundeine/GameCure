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
                            HStack{
                                Image(systemName: "person.circle.fill")
                            Text("My Profile")
                            }
                        })
                    HStack{
                        Image(systemName: "heart.fill")
                        Text("Experience")
                        Spacer()
                        Text("\(session.session?.experience ?? 0)")
                        }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Posts")
                    }.onTapGesture {
                        print("Posts")
                    }
                    HStack {
                        Image(systemName: "x.circle.fill")
                        Text("Logout")
                    }
                        .onTapGesture {
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
    
        @EnvironmentObject var session: SessionStore
    
        @Environment(\.presentationMode) var presentationMode
    
        @State var editProfile = false
        var body: some View {
            VStack {
                
                VStack(alignment: .leading){
                    HStack{
                        if(editProfile){
                            Text("Cancel").onTapGesture {
                                editProfile = false
                            }
                            .font(.system(size: 20))
                            
                        } else {
                            Text("Edit Profile").onTapGesture {
                                editProfile = true
                            }
                            .font(.system(size: 20))
                            
                        }
                        
                        Spacer()
                        Text("Dismiss").onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.system(size: 20))
                    }.padding(15)
                }
            //TODO: add dismiss button
                MyProfile(editProfile: $editProfile)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                
            }
        }
    }


