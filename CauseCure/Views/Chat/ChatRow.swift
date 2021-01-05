//
//  ChatRow.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 05.01.21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatRow: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow()
    }
}


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
