//
//  ChallengeCellDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 11.12.20.
//

import SwiftUI

struct ChallengeCellDetail: View {
    @ObservedObject var challengeCellVM: ChallengeCellViewModel
    @State var presentChallengeAFriend = false
//    @Binding var myChallenge 
    
    func completeChallenge() {
        challengeCellVM.challengeRepository.addChallengeToUser(challengeCellVM.challenge)
    }
    var body: some View {
            VStack {
                Text("\($challengeCellVM.challenge.title.wrappedValue)") .font(.title)
                Divider()
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Description")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                    }.padding()
                        HStack{
                            Text("\($challengeCellVM.challenge.description.wrappedValue)")
                            .font(.subheadline)
                        }.padding()
                    HStack(alignment: .top) {
                        Text("Inveral")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text("\($challengeCellVM.challenge.interval.wrappedValue)")
                            .font(.subheadline)
                    }.padding()
                    HStack(alignment: .top) {
                        Text("Duration in days")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text("\($challengeCellVM.challenge.durationDays.wrappedValue)")
                            .font(.subheadline)
                    }.padding()
                }
                Spacer()
            }
        Button(action: { self.presentChallengeAFriend.toggle()
            print("toggled")
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
            Text("Challenge a friend!")
            }
        }.padding()
        Button(action: {
            completeChallenge()
        }) {
            HStack {
            Text("Complete Challenge")
            }
        }.padding()
            
        }
}

//
//struct ChallengeCellDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeCellDetail()
//    }
//}
