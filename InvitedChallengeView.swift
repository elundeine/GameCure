//
//  InvitedChallengeView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.01.21.
//

import SwiftUI

struct InvitedSharedChallengeView: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
    @State var invitedBy = ""
    
    func acceptChallenge(){
        userChallengeCellVM.repository.acceptChallengeInviteFrom(userId: invitedBy, challengeId: userChallengeCellVM.id)
    }
    
    func declineChallenge(){
        userChallengeCellVM.repository.deleteChallengeInviteFrom(challengeId: userChallengeCellVM.id)
    }
    
    var body: some View {
        VStack{
            VStack {
                VStack {
                Image("trophy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    Text($userChallengeCellVM.userChallenge.title.wrappedValue)
                    .font(.title)
                    Text($userChallengeCellVM.userChallenge.description.wrappedValue)
                Divider()
                    
                }
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Duration")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text("\($userChallengeCellVM.userChallenge.durationDays.wrappedValue) days")
                            .font(.subheadline)
                    }.padding()
                    HStack(alignment: .top) {
                        Text("Challenged by")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text("\(invitedBy)")
                            .font(.subheadline)
                    }.padding()
                    Divider()
                    VStack {
                        HStack(alignment: .top) {
                        Spacer()
                        Text("Do you accept the challenge?")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        }
                        HStack(alignment: .top) {
                            Button(action: {
                                self.acceptChallenge()
                            }) {
                                HStack {
                                    Text("Yes")
                                        .fontWeight(.semibold)
                                        .font(.title)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(40)
                            }
                            Spacer()
                            Button(action: {
                                self.declineChallenge()
                            }) {
                                HStack {
                                    Text("No")
                                        .fontWeight(.semibold)
                                        .font(.title)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(40)
                            }

                    
                        }
                        Spacer()
                    }.padding()
                }
               
            }
        }
    }
}
//
//struct InvitedChallengeView_Previews: PreviewProvider {
//    static var previews: some View {
//        InvitedChallengeView()
//    }
//}
