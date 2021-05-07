//
//  Description.swift
//  CauseCure
//
//  Created by Oscar Lange on 12/29/20.
//

import SwiftUI

struct Description: View {
    
    @State var description:String
    @State var showDescription = false
    
    @State var age = ""
    @State var showAge = false
    
    @State var numberOfStones = ""
    @State var showNumberOfStones = false
    
    @State var biggestStone = ""
    @State var showBiggestStone = false
    
    @State var mood = "Doing Fine"
    @State var showMood = false
    
    @State var title = "Stone Cutter"
    @State var showTitle = false
    
    var body: some View {
        ScrollView {
            if(showDescription){
                textCard(titel: "Description", text: description)
            }
            if(showAge){
                textCardHorizontal(titel: "Age", text: age)
            }
            if(showNumberOfStones){
                textCardHorizontal(titel: "Number of Stones", text: numberOfStones)
            }
            if(showBiggestStone){
                textCardHorizontal(titel: "Biggest Stone", text: biggestStone)
            }
            if(showMood){
                textCardHorizontal(titel: "Status", text: mood)
            }
            if(showTitle){
                textCardHorizontal(titel: "Title", text: title)
            }
            if(!showDescription && !showAge && !showNumberOfStones && !showBiggestStone && !showMood && !showTitle){
                textCard(titel: "Empty Profile", text: "You haven't selected any Information to be shown here. Edit your profile to show yourself to the world!")
            }
        }
    }
}

