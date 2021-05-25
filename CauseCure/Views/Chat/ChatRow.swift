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
           
            if message.userID == uid {
                    HStack {
                        Spacer()
                        Text(message.lastMessage ?? "")
                            .modifier(chatModifier(myMessage: true))
                    }.padding(.leading,75)
                } else {
                    HStack {
                        Text(message.lastMessage ?? "")
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
                .frame(idealHeight: 20)
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

struct FollowerCard: View {
    @ObservedObject var userCellVM: FollowerCellViewModel
    
    var body: some View {
        HStack(alignment: .center) {
        WebImage(url: URL(string: userCellVM.follow.profileImageUrl))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: 120)
            .padding(.all, 20)
        
        VStack(alignment: .leading) {
                Text("\(userCellVM.follow.username)")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
//                HStack {
//                    Text("daily")
//                    .font(.system(size: 16, weight: .bold, design: .default))
//                    .foregroundColor(.white)
//                    .padding(.top, 8)
//                }
        }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}
