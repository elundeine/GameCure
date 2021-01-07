//
//  ChatRow.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 05.01.21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatRow : View {
    
    var message : Message
    var uid : String
    
    var body: some View {
        
        HStack {
           
                if message.sender == uid {
                    HStack {
                        Spacer()
                        Text(message.textMessage ?? "")
                            .modifier(chatModifier(myMessage: true))
                    }.padding(.leading,75)
                } else {
                    HStack {
                        Text(message.textMessage ?? "")
                            .modifier(chatModifier(myMessage: false))
                        Spacer()
                    }.padding(.trailing,75)
                }
            
        }
    }
}

//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow()
//    }
//}
//

struct ChatViewRow : View {
    @ObservedObject var userCellVM: UserCellViewModel
//    var message : Message
    
    
    var body : some View {
        HStack{
            WebImage(url: URL(string: userCellVM.user.profileImageUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(idealHeight: 10)
                .clipShape(Circle())
                .padding(.trailing,10)
            VStack(alignment: .leading, spacing: 3){
                HStack{
                    Text(userCellVM.user.username)
                        .font(.system(size: 15, weight: .semibold))
                    Spacer()
//                    Text("\(message.timestamp?.timeStringConverter ?? "")")
//                        .font(.system(size: 12, weight: .regular))
//                        .foregroundColor(.blue)
                }
//                Text(message.text ?? "")
//                    .font(.system(size: 12, weight: .medium))
//                    .foregroundColor(.secondary)
            }
        }
    }
}
