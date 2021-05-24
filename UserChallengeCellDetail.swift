//
//  UserChallengecellDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 23.12.20.
//

import SwiftUI
import AlertX

struct UserChallengeCellDetail: View {
        @ObservedObject var session: SessionStore
        @ObservedObject var repository : Repository
        @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
        @ObservedObject var completedChallengeCellVM: CompletedChallengeCellViewModel

        @StateObject var userListVM : UserListViewModel
        @StateObject var followerListVM : FollowerListViewModel

        @State var challengeDone = false
        @State var showCompleteChallengeAlert = false
        @State var progressValue: Float = 0.0
        @State var doneToday = false
        @State var experience = 0
        @State var challengeEnded = false
        @State var timesCompleted = 0
    
        @State var showModal = false
        @State var recommendChallengeToFriendPresented = false
        @State var challengeFriendPresented = false
    
    init(session: SessionStore, repository: Repository, userChallengeCellVM: UserChallengeCellViewModel, completedChallengeCellVM: CompletedChallengeCellViewModel) {
        self.session = session
        self.repository = repository
        self.userChallengeCellVM = userChallengeCellVM
        self.completedChallengeCellVM = completedChallengeCellVM
        _userListVM = StateObject(wrappedValue: UserListViewModel(repository: repository))
        _followerListVM = StateObject(wrappedValue: FollowerListViewModel(repository: repository))
    }
    
    func completeChallenge() {
            print("completing challenge")
        
            self.experience = 50
            self.showCompleteChallengeAlert.toggle()
            self.doneToday = true
            self.timesCompleted += 1
            userChallengeCellVM.repository.completeAChallenge(challenge: userChallengeCellVM.userChallenge, username: session.session?.username ?? "")
            let timesCompletedTemp = 100 * self.timesCompleted
             
            let duration = userChallengeCellVM.userChallenge.durationDays
            let progress = Float((timesCompletedTemp) / (duration))
            print(progress)
            self.progressValue = progress / 100
            print(self.progressValue)
        if (completedChallengeCellVM.checkIfTodayIsLastDay()) {
                // end challenge
//                self.challengeDone = true
//                endChallenge()
        }
    }
    func stopChallenge() {
        if (timesCompleted > 0) {
            userChallengeCellVM.repository.challengeDone(challenge: userChallengeCellVM.userChallenge, timesCompleted: timesCompleted)
        } else {
            userChallengeCellVM.repository.removeChallengefromUser(userChallengeCellVM.userChallenge)
        }
    }
    func endChallenge() {
        userChallengeCellVM.repository.challengeDone(challenge: userChallengeCellVM.userChallenge, timesCompleted: timesCompleted)
    }
    
    func progressSetup() {
        
//        if (completedChallengeCellVM.checkIfChallengeIsOver() == false) {
            if completedChallengeCellVM.completedChallenge.timesCompleted != 0 {
                print("completed before!!!")
                let timesCompletedTemp = 100 * completedChallengeCellVM.completedChallenge.timesCompleted!
                self.timesCompleted = timesCompletedTemp / 100
                let duration = userChallengeCellVM.userChallenge.durationDays
                print(timesCompleted)
                print(duration)
                let progress = Float((timesCompletedTemp) / (duration))
                print(progress)
                self.progressValue = progress / 100
                self.doneToday = completedChallengeCellVM.checkIfCompletedToday()
                print(progressValue)
                
            } else {
                
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
                    VStack {
                        if(self.timesCompleted == 0) {
                            Image("trophy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                            Text($userChallengeCellVM.userChallenge.title.wrappedValue)
                                .font(.title)
                            Text($userChallengeCellVM.userChallenge.description.wrappedValue)
                        
                        } else {
                            ProgressBar(progress: self.$progressValue)
                                .frame(width: 150.0, height: 150.0)
                                .padding(40.0)
                            Text($userChallengeCellVM.userChallenge.title.wrappedValue)
                                .font(.title)
                            Text($userChallengeCellVM.userChallenge.description.wrappedValue)
                        }
                        
                    }
                    Divider()
                    VStack(alignment: .leading) {
//                        HStack(alignment: .top) {
//                            Text("Completed by Community")
//                                .font(.subheadline)
//                                .bold()
//                            Spacer()
//                            Text("\(userChallengeCellVM.numberOfCompletions + challengeCompletedIncrement) times")
//                                .font(.subheadline)
//                        }.padding()
                        HStack(alignment: .top) {
                            Text("Completed by me")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            //                            Text("id: \(completedChallengeCellVM.id)")
                            Text("\((self.timesCompleted)) / \(userChallengeCellVM.userChallenge.durationDays) times")
                                .font(.subheadline)
                        }.padding()
                       
                        // Mark: History
//                        if (completedChallengeCellVM.completedChallenge.timesCompleted != 0) {
//                        VStack {
//                            HStack(alignment: .top) {
//                                Text("History")
//                                    .font(.subheadline)
//                                    .bold()
//                                Spacer()
//                            }
//
//                            ScrollView(.horizontal){
//                                HStack(alignment: .top) {
//                                ForEach(completedChallengeCellVM.history, id:\.self) { historyEntry in
//                                    ZStack {
//                                        Rectangle().fill(Color.white).cornerRadius(10).shadow(color:.blue, radius: 6, x: 1, y: 1).frame(width: 80, height: 80)
//                                        VStack {
//                                            Text("\(Date(timeIntervalSince1970: historyEntry).getTodaysDate())").font(.subheadline)
//                                            Text(Date(timeIntervalSince1970: historyEntry).month).font(.subheadline)
//                                        }
//
//                                    }.padding(2)
//
//
//                                }
//                            }
//                            }
//
//                        }.padding()
//                        }
                        if (completedChallengeCellVM.challengeDays != nil) {
                        VStack {
                            HStack(alignment: .top) {
                                Text("Days to go")
                                    .font(.subheadline)
                                    .bold()
                                Spacer()
                            }
                          
                            ScrollView(.horizontal){
                                HStack(alignment: .top) {
                                ForEach(completedChallengeCellVM.challengeDays, id:\.self) { challengeEntry in
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
                            } else {
                                HStack(alignment: .top) {
                                Spacer()
                                HStack {
                                    Text("Done for Today!")
                                        .foregroundColor(Color.white)
                                }.frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
                                .background(Color.blue)
                                .cornerRadius(5)
                                .padding()
                                Spacer()
                                }
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
                            HStack(alignment: .top) {
                                Spacer()
                                Button(action: {
                                    self.challengeFriendPresented.toggle()
                                    self.showModal.toggle()
                                }) {
                                    HStack {
                                        Text("Start the challenge with a friend!")
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
                            Text("by \($userChallengeCellVM.userChallenge.challengeCreater.wrappedValue)")
                                .font(.subheadline)
                            Spacer()
                          
                        }.padding()
                    }
                    Spacer()
                }
            }
            .onAppear(perform: self.progressSetup)
            .alert(isPresented: $showCompleteChallengeAlert) {
                Alert(title: Text("Completed for Today! Congratulation!"), message: Text("You earned \(self.experience) CauseCoins"), dismissButton: .default(Text("Ok")))
            }
//            .alertX(isPresented: $showCompleteChallengeAlert) {
//
//                AlertX(title: Text("Completed for Today! Congratulation!"),
//                       primaryButton: .default(Text("You earned \(self.experience) CauseCoins")),
//                           theme: .light(withTransparency: true, roundedCorners: true))
//
//
//            }
//            .alertX(isPresented: $challengeDone) {
//                
////                AlertX(title: Text("Congratulations you went throw the whole challenge!"),
////                       primaryButton: .default(Text("You earned completed the challenge \(self.timesCompleted) / \(userChallengeCellVM.userChallenge.durationDays) times. You will extra CauseCoins when you stick to the Challenge.")),
////                           theme: .light(withTransparency: true, roundedCorners: true))
////
////
////            }
            .fullScreenCover(isPresented: $showModal) { FriendModalView(session: session, userListVM: userListVM, followerListVM: followerListVM, userChallengeCellVM: userChallengeCellVM, recommendFollower: $recommendChallengeToFriendPresented,challengeFollower: $challengeFriendPresented)
            }
            
            } else {
                Text("Congratulations you completed the challenge!")
                Text("you earned yourself bonus CauseCoins!")
            }
        }
}
struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}

struct FriendModalView: View {
        @ObservedObject var session: SessionStore
        @ObservedObject var userListVM: UserListViewModel
        @ObservedObject var followerListVM: FollowerListViewModel
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
        @State var challengeFriendAlert = false
        @Binding var recommendFollower: Bool
        @Binding var challengeFollower: Bool
    
    func recommendChallengeToFollower(userID: String, username: String) {
        print("User \(userID) was recommended challenged")
        userListVM.repository.sendChallengeInvite(challengedUserId: userID, challengedUsername: username, myUsername: session.session?.username ?? "", challengeId: userChallengeCellVM.challengeId, challengeTitle: userChallengeCellVM.userChallenge.title, challengeDescription: userChallengeCellVM.userChallenge.description, challengeCreater: userChallengeCellVM.userChallenge.challengeCreater, challengeInterval: userChallengeCellVM.userChallenge.interval, durationDays: userChallengeCellVM.userChallenge.durationDays, shared: false)
        
        self.challengeFriendAlert = true
    }
    func challengeFollower(userID: String, username: String) {
        print("User \(userID) was challenged")
        userListVM.repository.sendChallengeInvite(challengedUserId: userID, challengedUsername: username, myUsername: session.session?.username ?? "", challengeId: userChallengeCellVM.challengeId, challengeTitle: userChallengeCellVM.userChallenge.title, challengeDescription: userChallengeCellVM.userChallenge.description, challengeCreater: userChallengeCellVM.userChallenge.challengeCreater, challengeInterval: userChallengeCellVM.userChallenge.interval, durationDays: userChallengeCellVM.userChallenge.durationDays, shared: true)
        
        self.challengeFriendAlert = true
    }
    
    var body: some View {
        //TODO: add dismiss button
        if (challengeFollower){
        VStack{
            HStack {
                Spacer()
                Image(systemName: "xmark").onTapGesture {
                    self.challengeFollower = false
                    presentationMode.wrappedValue.dismiss()
                }.padding()
                
            }
            Text("Challenge a Follower").font(.title)
            List {
                ForEach(followerListVM.followerCellViewModels) {
                    userCellVM in
                    
                    Text("follower")
                    FriendCard(userCellVM: userCellVM)
                        .onTapGesture {
                            challengeFollower(userID: userCellVM.id, username: userCellVM.follow.username)
                        }
                
            }
        }
        Spacer()
        .alert(isPresented: $challengeFriendAlert) {
            Alert(title: Text("Sent out a challenge invite!"), message: Text("The challenge invitation is now displayed in your followers dashboard."), dismissButton: .default(Text("Ok")))
        }
        }
    } else {
    VStack{
        HStack {
            Spacer()
            Image(systemName: "xmark").onTapGesture {
                self.recommendFollower = false
                presentationMode.wrappedValue.dismiss()
            }.padding()
            
        }
        Text("Recommend to a Follower").font(.title)
        
        List {
            
            //
            ForEach(followerListVM.followerCellViewModels) {
                userCellVM in
                
                
                FriendCard(userCellVM: userCellVM)
                    .onTapGesture {
                        recommendChallengeToFollower(userID: userCellVM.id, username: userCellVM.follow.username)
                    }
            }
        }
    
    }
    Spacer()
    .alert(isPresented: $challengeFriendAlert) {
        Alert(title: Text("Sent out a challenge invite!"), message: Text("The challenge invitation is now displayed in your followers dashboard."), dismissButton: .default(Text("Ok")))
    }
    }
    }
}
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


extension Date {
    var month: String {
        let names = Calendar.current.monthSymbols
        let month = Calendar.current.component(.month, from: self)
        return names[month - 1]
    }
    func getHumanReadableDayString() -> String {
            let weekdays = [
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday"
            ]
            
            let calendar = Calendar.current.component(.weekday, from: self)
            return weekdays[calendar - 1]
        }
    
    func getTodaysDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
}
