//
//  TabBar.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI


struct TabBar: View {
    
    //@EnvironmentObject var model: Model
    
    var body: some View {
        TabView {
            Community()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("")
                }//.environmentObject(model)
            AddCreateChallenge()
                .tabItem {
                    Image(systemName: "plus")
                    Text("")
                }
            ChallengeGrid()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("")
                }//.environmentObject(model)
        }
    }
}
