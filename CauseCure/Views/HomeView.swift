//
//  HomeView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        
        VStack {
        Text("Home View")
            Button(action: session.logout) {
                Text("Log out").font(.title).modifier(ButtonModifier())
                
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
