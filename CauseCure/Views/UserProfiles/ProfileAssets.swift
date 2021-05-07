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

struct textCard: View {
    
    @State var titel = ""
    @State var text = ""
    
    var body: some View {
        VStack(spacing: 15){
            Text(titel)
                .fontWeight(.semibold)
                .padding(.top, 10)
            Text(text)
                .fontWeight(.semibold)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 10)
        }.frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
        .foregroundColor(Color.white)
    }
}

struct textCardHorizontal: View {
    
    @State var titel = ""
    @State var text = ""
    
    var body: some View {
        HStack(){
            Text(titel)
                .fontWeight(.semibold)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.leading, 20)
            Spacer()
            Text(text)
                .fontWeight(.semibold)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.trailing, 20)
        }.frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.bottom, 10)
        .foregroundColor(Color.white)
    }
}
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
        .padding(.all, 20)
        if(showText){
            TextField("", text: $text)
                .onReceive(Just(text)) { newValue in
                    if(newValue.count > textLimit) {
                        text = String(text.prefix(textLimit))
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.white, width: 1.0)
                .padding(.bottom, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .foregroundColor(Color.black)
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
        VStack {
            HStack{
                Text(name)
                Spacer()
                Toggle(isOn: $showNumber) {
                }
            }
            .padding(.all, 20)
            if(showNumber){
            TextField("", text: $number)
                .onReceive(Just(number)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        number = filtered
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.white, width: 1.0)
                .padding(.bottom, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .foregroundColor(Color.black)
            }
        }.frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
        .foregroundColor(Color.white)
    }
}

struct optionalPickerCard: View {
    
    @State var name = ""
    @Binding var showButton: Bool
    @Binding var sheetCase: Bool
    @Binding var showSheet: Bool
    @Binding var value: String
    
    
    var body: some View {
        VStack {
            HStack{
                Text(name)
                Spacer()
                Toggle(isOn: $showButton) {
                }
            }
            .padding(.top, 10)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            if(showButton){
                Button(action: {
                    self.sheetCase = true
                    self.showSheet = true
                }) {
                    Text(value)
                        .font(Font.title2.bold().lowercaseSmallCaps())
                        .multilineTextAlignment(.center)
                }.foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            }
            Spacer()
        }.frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .foregroundColor(Color.white)
    }
    
}

