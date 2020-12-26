//
//  SideMenuContent.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 20.12.20.
//

import SwiftUI

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
                    Button(action: {
                        withAnimation{
                            self.isPresented.toggle()
                        }
                        }, label: {
                            Text("My Profile")
                        })
                    Text("Posts").onTapGesture {
                        print("Posts")
                    }
                    Text("Logout").onTapGesture {
                        logOut()
                    }
                    .fullScreenCover(isPresented: $isPresented, content: FullScreenModalView.init)
                }
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


