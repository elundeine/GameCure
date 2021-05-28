//
//  ChallengeCellDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 11.12.20.
//

import SwiftUI

struct ChallengeCellDetail: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var challengeCellVM: ChallengeCellViewModel
    @State var presentChallengeAFriend = false
    @State var myChallenge: Bool = false
    @State var challengeCompletedIncrement = 0
    @State var showCompleteChallengeAlert = false
    @State var addedToMyChallenges = false
    @AppStorage("selectedTab") private var selectedTab = "magnifyingglass"
    func completeChallenge() {
        challengeCellVM.repository.completeAChallenge(challenge: challengeCellVM.challenge, username: session.session?.username ?? "")
    }
    
    func addToMyChallenges() {
        challengeCellVM.repository.addChallengeToUser(challenge: challengeCellVM.challenge, challengeId: challengeCellVM.challenge.id ?? "")
        selectedTab = "house.fill"
    }
    
    var body: some View {
        VStack{
            VStack {
                VStack {
                Image("trophy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                Text($challengeCellVM.challenge.title.wrappedValue)
                    .font(.title)
                    Text($challengeCellVM.challenge.description.wrappedValue)
                Divider()
                    
                }
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Completed by Community")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text("\(challengeCellVM.numberOfCompletions + challengeCompletedIncrement) times")
                            .font(.subheadline)
                    }.padding()
                    Divider()
                    VStack {
                        HStack(alignment: .top) {
                        Text("Leaderboard")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        }
                        HStack(alignment: .top) {
//                            Text("\(challengeCellVM.repository.getUsernameBy(challengeCellVM.leaderBoard.first?.0 ?? "")) ")
//                            Text("\(challengeCellVM.leaderBoard.first?.0 ?? "") ")
                        Spacer()
                        }
                        
                    }.padding()
                    if myChallenge {
                    HStack(alignment: .top) {
                        Button(action: { self.presentChallengeAFriend.toggle()
                            print("toggled")
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Challenge a friend!")
                                Spacer()
                            }
                        }.padding()
                        Spacer()
                    }.padding()
                    HStack(alignment: .top) {
                         Button(action: {
                            completeChallenge()
                        }) {
                                HStack {
                                    Spacer()
                                    Text("Complete Challenge")
                                    Spacer()
                                }
                        }.padding()
                        }
                    } else {
                        HStack(alignment: .top) {
                            Button(action: {
                                addToMyChallenges()
                            }) {
                                    HStack {
                                        Spacer()
                                        Text("Add to my Challenges")
                                        Spacer()
                                    }
                        }.padding()
                        }
                        
                    }
                }
               
            }
        }
        .alert(isPresented: $showCompleteChallengeAlert) {
            Alert(title: Text("Congratulation"), message: Text(""), dismissButton: .default(Text("Back to Challenge")))

    }
       
                
}
}
