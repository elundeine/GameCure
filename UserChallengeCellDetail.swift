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
        @State var challengeCompletedIncrement = 0
        
        func completeChallenge() {
            userChallengeCellVM.repository.completeChallenge(userChallengeCellVM.userChallenge)
            challengeCompletedIncrement += 1
        }
        var body: some View {
            VStack{
                VStack {
                    VStack {
                    Image("trophy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .padding(.all, 20)
                    Text($userChallengeCellVM.userChallenge.title.wrappedValue)
                        .font(.title)
                    Text($userChallengeCellVM.userChallenge.description.wrappedValue)
                    Divider()
                        
                    }
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("Completed by Community")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("\(userChallengeCellVM.numberOfCompletions + challengeCompletedIncrement) times")
                                .font(.subheadline)
                        }.padding()
                        HStack(alignment: .top) {
                            Text("Completed by me")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("\(userChallengeCellVM.userCompletions + challengeCompletedIncrement) times")
                                .font(.subheadline)
                        }.padding()
                        HStack(alignment: .top) {
                            Text("Challenge Created by")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text($userChallengeCellVM.userChallenge.challengeCreater.wrappedValue)
                                .font(.subheadline)
                        }.padding()
                        HStack(alignment: .top) {
                            Text("Leaderboard")
                                .font(.subheadline)
                                .bold()
                            Spacer()
//                            List {
//                                ForEach(userChallengeCellVM.leaderBoard, id:\.self) { dict in
//                                    Section {
//                                        SectionView(dict: dict)
//                                    }
//                                .font(.subheadline)
                        }.padding()
                        HStack(alignment: .top) {
                            Spacer()
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
                            Spacer()
                        }.padding()
                        HStack(alignment: .top) {
                            Spacer()
                            Button(action: {
                                completeChallenge()
                            }) {
                                    HStack {
                                        Text("Complete Challenge")
                                    }
                            }.padding()
                            Spacer()
                        }.padding()
                    }
                    Spacer()
                }
        }
    }
}
  
//struct SectionView : View {
//    @State var dict = (String, Int)()
//
//    var body: some View {
//        let keys = dict.map{$0.key}
//        let values = dict.map {$0.value}
//
//        return  ForEach(keys.indices) {index in
//            HStack {
//                Text(keys[index])
//                Text("\(values[index])")
//            }
//        }
//    }
//}
//
//struct UserChallengecellDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        UserChallengecellDetail()
//    }
//}
