//
//  PaymentCheck.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 15.01.21.
//

import SwiftUI

struct PaymentCheck: View {
    @EnvironmentObject var session: SessionStore
    @State var insufficientPayment = false
    @State var playing = false
    @State var boughtTicket = false
    
    func paymentCheck() {
        let experience = session.session?.experience ?? 0
        let userId = session.session?.uid ?? ""
        if (experience >= 50) {
            session.payforStoneCrusherGame(userId: userId, experience: experience)
            self.playing = true
            self.boughtTicket = true
        } else {
            print("not enough stones")
            self.insufficientPayment = true
        }
        
    }
    
    var body: some View {
        VStack{
            StoneCrusher(playing: $playing)
        }
    }
    
}
struct PaymentCard: View {
    
    
    var body: some View {
        HStack(alignment: .center) {
            
            Image("kidney")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.all, 20)

            VStack(alignment: .leading) {
                Text("Tap to play StoneCrusher for 50 Stones.")
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}
