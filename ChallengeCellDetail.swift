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
    @State var myChallenge: Bool
    @State var challengeCompletedIncrement = 0
    @State var showCompleteChallengeAlert = false
    
    func completeChallenge() {
        challengeCellVM.repository.completeChallenge(challengeCellVM.challenge)
    }
    
    func addToMyChallenges() {
        challengeCellVM.repository.addUserToChallenge(challengeId: challengeCellVM.challenge.id ?? "")
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
                    HStack(alignment: .top) {
                        Text("Challenge Created by")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text($challengeCellVM.challenge.challengeCreater.wrappedValue)
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
                            Text("\(challengeCellVM.repository.getUsernameBy(challengeCellVM.leaderBoard.first?.0 ?? "")) ")
                            Text("\(challengeCellVM.leaderBoard.first?.0 ?? "") ")
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

//
//struct ChallengeCellDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeCellDetail()
//    }
//}
