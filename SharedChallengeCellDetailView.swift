//
//  UserChallengecellDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 23.12.20.
//

import SwiftUI
import AlertX

struct SharedChallengeCellDetailView: View {
        @ObservedObject var session: SessionStore
        @ObservedObject var repository: Repository
        @ObservedObject var sharedChallengeCellVM: SharedChallengeCellViewModel
        @ObservedObject var completedChallengeCellVM: SharedCompletedChallengeCellViewModel
        @ObservedObject var sharedCompletedChallengeCellVM: SharedCompletedChallengeCellViewModel
        @StateObject var followerListVM : FollowerListViewModel
        @StateObject var userListVM : UserListViewModel
        
        @State var challengeDone = false
        @State var showCompleteChallengeAlert = false
        @State var progressValue: Float = 0.0
        @State var sharedProgressValue: Float = 0.0
        @State var doneToday = false
        @State var sharedDoneToday = false
        @State var experience = 0
        @State var challengeEnded = false
        @State var timesCompleted = 0
        @State var sharedTimesCompleted = 0
        @State var showModal = false
        @State var recommendChallengeToFriendPresented = false
        @State var challengeFriendPresented = false
        @State var challengeDays = [0.0]
    init(session: SessionStore, repository: Repository, sharedChallengeCellVM: SharedChallengeCellViewModel, completedChallengeCellVM: SharedCompletedChallengeCellViewModel, sharedCompletedChallengeCellVM: SharedCompletedChallengeCellViewModel ) {
        self.session = session
        self.repository = repository
        self.sharedChallengeCellVM = sharedChallengeCellVM
        self.completedChallengeCellVM = completedChallengeCellVM
        self.sharedCompletedChallengeCellVM = sharedCompletedChallengeCellVM
        _userListVM = StateObject(wrappedValue: UserListViewModel(repository: repository))
        _followerListVM = StateObject(wrappedValue: FollowerListViewModel(repository: repository))
    }
    func completeChallenge() {
            print("completing challenge")
        
            self.experience = 50
            self.showCompleteChallengeAlert.toggle()
            self.doneToday = true
            self.timesCompleted += 1
            sharedChallengeCellVM.repository.completeSharedChallenge(challenge: sharedChallengeCellVM.sharedChallenge, username: session.session?.username ?? "")
            let timesCompletedTemp = 100 * self.timesCompleted
             
            let duration = sharedChallengeCellVM.sharedChallenge.durationDays
            let progress = Float((timesCompletedTemp) / (duration))
            print(progress)
            self.progressValue = progress / 100
            print(self.progressValue)
            self.challengeDays = completedChallengeCellVM.challengeDays
        if (completedChallengeCellVM.checkIfTodayIsLastDay()) {
                // end challenge
//                self.challengeDone = true
//                endChallenge()
        }
    }
    
    //TODO
    func stopChallenge() {
        if (timesCompleted > 0) {
//            userChallengeCellVM.repository.challengeDone(challenge: userChallengeCellVM.userChallenge, timesCompleted: timesCompleted)
        } else {
//            userChallengeCellVM.repository.removeChallengefromUser(userChallengeCellVM.userChallenge)
        }
    }
    func endChallenge() {
//        userChallengeCellVM.repository.challengeDone(challenge: userChallengeCellVM.userChallenge, timesCompleted: timesCompleted)
    }
    
    func progressSetup() {
//        if (completedChallengeCellVM.checkIfChallengeIsOver() == false) {
            print("Mike completed: \(completedChallengeCellVM.completedChallenge.id)")
            print("hannah completed: \(sharedCompletedChallengeCellVM.completedChallenge.id)")
            self.challengeDays = completedChallengeCellVM.challengeDays
            if completedChallengeCellVM.completedChallenge.timesCompleted != 0 {
                let timesCompletedTemp = 100 * completedChallengeCellVM.completedChallenge.timesCompleted!
                self.timesCompleted = timesCompletedTemp / 100
                let duration = sharedChallengeCellVM.sharedChallenge.durationDays
                let progress = Float((timesCompletedTemp) / (duration))
                self.progressValue = progress / 100
                self.doneToday = completedChallengeCellVM.checkIfCompletedToday()
            }
            if sharedCompletedChallengeCellVM.completedChallenge.timesCompleted != 0 {
                let sharedTimesCompletedTemp = 100 * sharedCompletedChallengeCellVM.completedChallenge.timesCompleted!
                self.sharedTimesCompleted = sharedTimesCompletedTemp / 100
                let sharedDuration = sharedChallengeCellVM.sharedChallenge.durationDays
                let sharedProgress = Float((sharedTimesCompletedTemp) / (sharedDuration))
                self.sharedProgressValue = sharedProgress / 100
                self.sharedDoneToday = sharedCompletedChallengeCellVM.checkIfCompletedToday()
            }
            
//        } else {
//            self.challengeDone = true
//            endChallenge()
//            
//        }
        
    }
    
    var body: some View {
            if (self.challengeEnded == false) {
            ScrollView{
                VStack {
                    HStack{
                        Text($sharedChallengeCellVM.sharedChallenge.title.wrappedValue)
                            .font(.title)
                    }
                    VStack {
                        HStack{
                            VStack{
                            if(self.timesCompleted == 0) {
                                Image("trophy")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100)
                            
                                } else {
                            
                                    ProgressBar(progress: self.$progressValue)
                                        .frame(width: 120, height: 120)
                                        .padding(40.0)
                                }
                                Text(session.session?.username ?? "")
                                    .bold()
                                    .font(.subheadline)
                            }
                            
                            VStack{
                                if(sharedCompletedChallengeCellVM.completedChallenge.timesCompleted == 0) {
                                    Image("trophy")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                } else {
                                    ProgressBar(progress: self.$sharedProgressValue)
                                        .frame(width: 120, height: 120)
                                        .padding(40.0)
                                }
                                Text(sharedCompletedChallengeCellVM.completedChallenge.username)
                                    .bold()
                                    .font(.subheadline)
                            }
                        
                        }
                        Divider()
                    }
                    
                    HStack(alignment: .top) {
                    if (self.doneToday){
                        
                        HStack {
                            Image(systemName: "checkmark")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(40)
                        
                    } else {
                        HStack {
                            Image(systemName: "xmark")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(40)
                    }
                    
                        VStack{
                        Spacer()
                        
                        Text("Done Today")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.subheadline)
                            
                        Spacer()
                        }
                if(self.sharedDoneToday){
                    
                    HStack {
                        Image(systemName: "checkmark")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(40)
                    
                    } else {
                HStack {
                    Image(systemName: "xmark")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(40)
                    }
                
                }.padding()
                VStack(alignment: .leading) {
//                        HStack(alignment: .top) {
//                            HStack {
//                                Text("\((self.timesCompleted)) / \(userChallengeCellVM.userChallenge.durationDays)")
//                                }
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(Color.gray)
//                                .cornerRadius(40)
//
//
//                           Spacer()
//                            VStack{
//
//                                Text("Completed times")
//                                    .font(.subheadline)
//                                    .bold()
//
//
//                            }
//                            Spacer()
//                            Text("\((self.sharedTimesCompleted)) / \(userChallengeCellVM.userChallenge.durationDays)")
//                                .font(.subheadline)
//                        }.padding()
//                        Divider()
                    VStack{
                    HStack(alignment: .top) {
                        Text("Challenge Description")
                            .font(.subheadline)
                            .bold()
                            .padding()
                        Spacer()
                    }.padding()
                        HStack{
                            Text($sharedChallengeCellVM.sharedChallenge.description.wrappedValue)
                            Spacer()
                        }
                    }.padding()
                   
                    if (completedChallengeCellVM.challengeDays.isEmpty != true) {
                        VStack {
                            HStack(alignment: .top) {
                                Text("Your days to go")
                                    .font(.subheadline)
                                    .bold()
                                Spacer()
                            }.padding()
                          
                            ScrollView(.horizontal){
                                HStack(alignment: .top) {
                                ForEach(challengeDays, id:\.self) { challengeEntry in
                                    ZStack {
                                        Rectangle().fill(Color.white).cornerRadius(10).shadow(color: completedChallengeCellVM.challengeCompletedThat(dayAsDouble: challengeEntry), radius: 6, x: 1, y: 1).frame(width: 80, height: 80)
                                        VStack {
                                            Text("\(Date(timeIntervalSince1970: challengeEntry).getTodaysDate())").font(.subheadline)
                                            Text(Date(timeIntervalSince1970: challengeEntry).month).font(.subheadline)
                                        }
                                                
                                    }.padding(2)
                                   
                                    
                                }
                            }
                            }
                            
                        }.padding()
                        }
                        if(self.timesCompleted != 0) {
                            if(self.doneToday == false) {
                        HStack(alignment: .top) {
                            Spacer()
                            Button(action: {
                                completeChallenge()
                            }) {
                                HStack {
                                    Text("Complete Challenge")
                                        .foregroundColor(Color.white)
                                }
                            }.frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .padding()
                            Spacer()
                        }.padding()
                            }
                        HStack(alignment: .top) {
                            Spacer()
                            Button(action: {
                                self.recommendChallengeToFriendPresented.toggle()
                                self.showModal.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("Recommend the challenge to a friend!")
                                }.foregroundColor(Color.white)
                            }.frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .padding()
                            Spacer()
                        }.padding()
                        } else {
                            HStack(alignment: .top) {
                                Spacer()
                                Button(action: {
                                    completeChallenge()
                                }) {
                                    HStack {
                                        Text("Complete Challenge for the first time")
                                            .foregroundColor(Color.white)
                                    }
                                }.frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
                                .background(Color.blue)
                                .cornerRadius(5)
                                .padding()
                                Spacer()
                            }.padding()
                        }
                        HStack(alignment: .top) {
                            Spacer()
                            Button(action: {
                                self.stopChallenge()
                            }) {
                                HStack {
                        
                                    Text("Stop Challenge")
                                        .foregroundColor(Color.white)
                                }
                            }.frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .padding()
                            Spacer()
                        }.padding()
                        HStack(alignment: .top) {
                            Spacer()
                            Text("by \($sharedChallengeCellVM.sharedChallenge.challengeCreator.wrappedValue)")
                                .font(.subheadline)
                            Spacer()
                          
                        }.padding()
                    }
                    Spacer()
                }
            }.padding()
            .onAppear(perform: self.progressSetup)
            .alert(isPresented: $showCompleteChallengeAlert) {
                Alert(title: Text("Completed for Today! Congratulation!"), message: Text("You earned \(self.experience) CauseCoins"), dismissButton: .default(Text("Ok")))
            }
//            .alertX(isPresented: $challengeDone) {
//                
//                AlertX(title: Text("Congratulations you went throw the whole challenge!"),
//                       primaryButton: .default(Text("You earned completed the challenge \(self.timesCompleted) / \(userChallengeCellVM.userChallenge.durationDays) times. You will extra CauseCoins when you stick to the Challenge.")),
//                           theme: .light(withTransparency: true, roundedCorners: true))
//
//                
//            }
//            .fullScreenCover(isPresented: $showModal) { FriendModalView(session: session, userListVM: userListVM, followerListVM: followerListVM, userChallengeCellVM: userChallengeCellVM, recommendFollower: $recommendChallengeToFriendPresented,challengeFollower: $challengeFriendPresented)
//            }
            
            } else {
                Text("Congratulations you completed the challenge!")
                Text("you earned yourself bonus CauseCoins!")
            }
        }
}

struct InfoCard: View {
    @ObservedObject var completedChallengeCellVM: CompletedChallengeCellViewModel
    @ObservedObject var sharedCompletedChallengeCellVM: CompletedChallengeCellViewModel
    var body: some View {
        HStack(alignment: .center) {
        Image("trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .padding(.all, 20)
        
        VStack(alignment: .leading) {
                Text("Test")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
//                HStack {
//                    Text("daily")
//                    .font(.system(size: 16, weight: .bold, design: .default))
//                    .foregroundColor(.white)
//                    .padding(.top, 8)
//                }
        }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.blue)
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}
