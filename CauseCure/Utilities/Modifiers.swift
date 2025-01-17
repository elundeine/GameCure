//
//  Modifiers.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 12.12.20.
//

import Foundation
import SwiftUI


struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}


struct chatModifier : ViewModifier{
    var myMessage : Bool
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(myMessage ? Color.blue : Color("bg1"))
            .cornerRadius(7)
            .foregroundColor(Color.white)
    }
}
