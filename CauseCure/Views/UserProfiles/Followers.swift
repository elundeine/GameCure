//
//  Followers.swift
//  CauseCure
//
//  Created by Oscar Lange on 1/5/21.
//

import SwiftUI

struct Followers: View {
    
@EnvironmentObject var session: SessionStore

var body: some View {
    
    VStack(alignment: .leading, spacing: 15){
        HStack(){
            Text("Publications")
                .fontWeight(.semibold)
            Spacer()
            Text("100")
                .fontWeight(.semibold)
        }
        HStack(){
            Text("Followers")
                .fontWeight(.semibold)
            Spacer()
            Text("\(session.session!.followers?.count ?? 0)")
                .fontWeight(.semibold)
        }
        HStack(){
            Text("Experience")
                .fontWeight(.semibold)
            Spacer()
            Text("\(session.session!.experience)")
                .fontWeight(.semibold)
        }
        HStack(){
            Text("Points")
                .fontWeight(.semibold)
            Spacer()
            Text("1984 Stone Coins")
                .fontWeight(.semibold)
                    }
            }.padding(EdgeInsets(top:10, leading:10, bottom:10, trailing: 10))
    }
}
