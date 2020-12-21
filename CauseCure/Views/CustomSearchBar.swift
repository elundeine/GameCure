//
//  CustomSearchBar.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 21.12.20.
//

import SwiftUI
import UIKit

struct CustomSearchBar: View {
    @Binding var challenges : [Challenge]
    @State var txt = ""
    var body: some View {
        VStack {
            HStack{
                TextField("Search", text: self.$txt)
                if self.txt != "" {
                    Button(action: {
                        
                    }) {
                        Text("Cancel")
                    }
                    .foregroundColor(.black)
                }
            }.padding()
            if self.txt != "" {
                
                if self.challenges.filter ({$0.title.lowercased().contains(self.txt.lowercased())}).count == 0 {
                    Text("No Results Found").foregroundColor(Color.black.opacity(0.5)).padding()
                } else {
                    List(self.challenges.filter { $0.title.lowercased().contains(self.txt.lowercased())}) { i in
                
                        Text(i.title)
                    }.frame(height: UIScreen.main.bounds.height / 5)
                }
            
            }
        }.background(Color.white)
    
    }
}
//
//struct CustomSearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomSearchBar()
//    }
//}
