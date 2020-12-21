//
//  CustomSearchBar.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 21.12.20.
//

import SwiftUI

struct CustomSearchBar: View {
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
            }
            .padding()
        }
        .background(Color.white)
    }
    
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar()
    }
}
