//
//  ProfileAssets.swift
//  CauseCure
//
//  Created by Oscar Lange on 1/12/21.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import Combine

struct optionalTextCard: View {
    
    @State var name = ""
    @Binding var showText: Bool
    @Binding var text: String
    @State var textLimit = 0
    
    var body: some View {
        VStack{
        HStack{
            Text(name)
            Spacer()
            Toggle(isOn: $showText) {
            }
        }
        if(showText){
            TextField("", text: $text)
                .onReceive(Just(text)) { newValue in
                    if(newValue.count > textLimit) {
                        text = String(text.prefix(textLimit))
                    }
                }
                .border(Color.black, width: 1.0)
        }
    } .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
        .foregroundColor(Color.white)
    }
}


struct optionalNumberCard: View {
    
    @State var name = ""
    @Binding var showNumber: Bool
    @Binding var number: String
    
    var body: some View {
        HStack{
        Text(name)
        Spacer()
        Toggle(isOn: $showNumber) {
        }
        }
        if(showNumber){
        TextField("", text: $number)
            .onReceive(Just(number)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    number = filtered
                }
            }
            .border(Color.black, width: 1.0)
        }
        }
}

struct optionalPickerCard: View {
    
    @State var name = ""
    @Binding var showButton: Bool
    @Binding var sheetCase: Bool
    @Binding var showSheet: Bool
    @Binding var value: String
    
    
    var body: some View {
    HStack{
        Text(name)
        Spacer()
        Toggle(isOn: $showButton) {
        }
    }
        if(showButton){
        Button(value) {
            self.sheetCase = true
            self.showSheet = true
        }
        }
       
    }
    
}

