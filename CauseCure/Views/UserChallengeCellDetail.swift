//
//  UserChallengecellDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 23.12.20.
//

import SwiftUI

struct UserChallengeCellDetail: View {
        @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
        @State var presentChallengeAFriend = false
        
        func completeChallenge() {
            userChallengeCellVM.repository.addChallengeToUser(userChallengeCellVM.userChallenge)
        }
        var body: some View {
                VStack {
                    Text("\($userChallengeCellVM.userChallenge.title.wrappedValue)") .font(.title)
                    Divider()
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("Description")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                        }.padding()
                            HStack{
                                Text("\($userChallengeCellVM.userChallenge.description.wrappedValue)")
                                .font(.subheadline)
                            }.padding()
                        HStack(alignment: .top) {
                            Text("Inveral")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("\($userChallengeCellVM.userChallenge.interval.wrappedValue)")
                                .font(.subheadline)
                        }.padding()
                        HStack(alignment: .top) {
                            Text("Duration in days")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("\($userChallengeCellVM.userChallenge.durationDays.wrappedValue)")
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
//struct UserChallengecellDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        UserChallengecellDetail()
//    }
//}
