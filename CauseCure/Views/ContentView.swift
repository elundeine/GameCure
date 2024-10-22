//
//  ContentView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session : SessionStore
    
    func listen() {
        session.listen()
    }
    
    var body: some View {
        Group {

            if (session.session != nil || session.isLoggedIn == true) {
                TabBar(session: session, repository: Repository())
            } else {
                SignInView(session: session)
            }
        }
        .onAppear(perform: listen)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
