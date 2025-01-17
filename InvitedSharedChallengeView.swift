//
//  InvitedSharedChallengeView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 22.01.21.
//

import SwiftUI

struct InvitedSharedChallengeView: View {
        @ObservedObject var session: SessionStore
        @ObservedObject var inviteCellVM: InviteCellViewModel

        
        func acceptChallenge(){
            inviteCellVM.repository.acceptSharedChallengeInviteFrom(userId: session.session?.uid ?? "", invite: inviteCellVM.invite)
        }
        
        func declineChallenge(){
            inviteCellVM.repository.deleteInvite(inviteCellVM.invite)
            
        }
    
        
        var body: some View {
            VStack{
                VStack {
                    VStack {
                    Image("trophy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        Text($inviteCellVM.invite.challengeTitle.wrappedValue)
                        .font(.title)
                        Text($inviteCellVM.invite.challengeDescription.wrappedValue)
                    Divider()
                        
                    }
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("Duration")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("\($inviteCellVM.invite.durationDays.wrappedValue) days")
                                .font(.subheadline)
                        }.padding()
                        HStack(alignment: .top) {
                            Text("Challenged by")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("\($inviteCellVM.invite.challengerUsername.wrappedValue)")
                                .font(.subheadline)
                        }.padding()
                        Divider()
                        
                        VStack {
                            HStack(alignment: .top) {
                            Spacer()
                            if (inviteCellVM.invite.shared == true ) {
                            Text("Do you want to do the challenge together with \($inviteCellVM.invite.challengerUsername.wrappedValue)?")
                                .font(.subheadline)
                                .bold()
                            } else {
                            Text("Do you accept the challenge?")
                                .font(.subheadline)
                                .bold()
                            }
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
