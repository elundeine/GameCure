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
        @State var showCompleteChallengeAlert = false
        var noLeaderboardEntries = ["first place", "second place", "third place" ]
        
        func completeChallenge() {
            userChallengeCellVM.repository.completeChallenge(userChallengeCellVM.userChallenge)
            challengeCompletedIncrement += 1
            self.showCompleteChallengeAlert.toggle()
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
                        Divider()
                        VStack {
                            HStack(alignment: .top) {
                            Text("Leaderboard")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            }
                            HStack(alignment: .top) {
                                Text("-\(userChallengeCellVM.repository.getUsernameBy(userChallengeCellVM.leaderBoard.first?.0 ?? ""))")
                                Text("--\(userChallengeCellVM.leaderBoard.first?.0 ?? "") ")
                                Text("---\(userChallengeCellVM.getUsernameFor(id: userChallengeCellVM.leaderBoard.first?.0 ?? "")) ")
                            Spacer()
                            }
                            
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
            .alert(isPresented: $showCompleteChallengeAlert) {
                Alert(title: Text("Congratulation"), message: Text(""), dismissButton: .default(Text("Back to Challenge")))

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
////
//struct UserChallengecellDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        UserChallengecellDetail()
//    }
//}


struct CustomAlertView: View {
    @Binding var show: Bool
    @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            VStack (spacing: 25) {
                Image ("trophy")
                
            Text("Congratulations")
                .font(.title)
                .foregroundColor(.black)
                if userChallengeCellVM.userCompletions > 1 {
                Text("You have completed \(userChallengeCellVM.userChallenge.title) \(userChallengeCellVM.userCompletions) times now, keep on going! ")
                    
                } else {
                Text("You have completed \(userChallengeCellVM.userChallenge.title) \(userChallengeCellVM.userCompletions) for your first time, let's see if you can keep it up")
                }
                Button(action: {}) {
                    Text("Back")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.horizontal, 25)
                        .background(Color.gray)
                        .clipShape(Capsule())
                }
                
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 30)
            .background(BlurView())
            .cornerRadius(25)
            
            Button(action: {
                withAnimation{
                    show.toggle()
                }
            }) {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.purple)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.35)
            )
    }
}

struct BlurView : UIViewRepresentable{
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
