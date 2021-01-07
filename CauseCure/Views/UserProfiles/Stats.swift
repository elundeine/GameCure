//
//  Description.swift
//  CauseCure
//
//  Created by Oscar Lange on 12/29/20.
//

import SwiftUI

struct Stats: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack(){
                Text("Challenges finished")
                    .fontWeight(.semibold)
                Spacer()
                Text("35")
                    .fontWeight(.semibold)
            }
            HStack(){
                Text("Current Challenges")
                    .fontWeight(.semibold)
                Spacer()
                Text("4")
                    .fontWeight(.semibold)
            }
            HStack(){
                Text("Active since")
                    .fontWeight(.semibold)
                Spacer()
                Text("10.12.2020")
                    .fontWeight(.semibold)
            }
            HStack(){
                Text("Title")
                    .fontWeight(.semibold)
                Spacer()
                Text("Stone Cutter")
                    .fontWeight(.semibold)
            }
        }.padding(EdgeInsets(top:10, leading:10, bottom:10, trailing: 10))
    }
}

struct Stats_Previews: PreviewProvider {
    static var previews: some View {
        Stats()
    }
}
