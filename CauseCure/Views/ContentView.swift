//
//  ContentView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sharedInt: SharedInt
    
    func listen() {
        session.listen()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                TabBar().environmentObject(SessionStore())
                    .environmentObject(SharedInt())
                
            } else {
                if self.sharedInt.myInt == 1{
                    TabBar().environmentObject(SessionStore())
                        .environmentObject(SharedInt())
                } else {
                    SignInView().environmentObject(SharedInt())
                }
            }
        }.onAppear(perform: listen)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
