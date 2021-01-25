//
//  Description.swift
//  CauseCure
//
//  Created by Oscar Lange on 12/29/20.
//

import SwiftUI

struct Stats: View {
    
    @State var challengesFinished: Bool
    @State var currentChallenges: Bool
    @State var activeSince: Bool
    
    var body: some View {
        if(challengesFinished){
            textCardHorizontal(titel: "Challenges finished", text: "35")
        }
        if(currentChallenges){
            textCardHorizontal(titel: "Current Challenges", text: "4")
        }
        if(activeSince){
            textCardHorizontal(titel: "Active since", text: "10.12.2020")
        }
        if(!challengesFinished && !currentChallenges && !activeSince){
            textCard(titel: "Empty Profile", text: "You haven't selected any Information to be shown here. Edit your profile to show yourself to the world!")
        }
    }
}
