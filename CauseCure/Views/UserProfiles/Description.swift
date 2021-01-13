//
//  Description.swift
//  CauseCure
//
//  Created by Oscar Lange on 12/29/20.
//

import SwiftUI

struct Description: View {
    var body: some View {
        VStack(spacing: 15){
            Text("Description")
                .fontWeight(.semibold)
            Text("I am a very cool Person! Unfortunatley I have very bad kidney stone pain, but I will manage this as I always do, because I am a strong person!")
                .fontWeight(.semibold)
        }.padding(EdgeInsets(top:20, leading:10, bottom:10, trailing: 10))
        
        VStack(alignment: .leading, spacing: 15){
            HStack(){
                Text("Age")
                    .fontWeight(.semibold)
                Spacer()
                Text("25")
                    .fontWeight(.semibold)
            }
            HStack(){
                Text("Number of Stones")
                    .fontWeight(.semibold)
                Spacer()
                Text("12")
                    .fontWeight(.semibold)
            }
            HStack(){
                Text("Biggest Stone")
                    .fontWeight(.semibold)
                Spacer()
                Text("3mm")
                    .fontWeight(.semibold)
            }
            HStack(){
                Text("Status")
                    .fontWeight(.semibold)
                Spacer()
                Text("IN PAIN!")
                    .fontWeight(.semibold)
            }
            HStack(){
                Text("Title")
                    .fontWeight(.semibold)
                Spacer()
                Text("Stone Cutter")
                    .fontWeight(.semibold)
            }
            
        }.padding(EdgeInsets(top:0, leading:10, bottom:10, trailing: 10))
    }
}

struct Description_Previews: PreviewProvider {
    static var previews: some View {
        Stats()
    }
}
