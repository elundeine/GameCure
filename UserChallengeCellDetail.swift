//
//  UserChallengecellDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 23.12.20.
//

import SwiftUI

struct UserChallengeCellDetail: View {
    
        @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
        @ObservedObject var completedChallengeCellVM: CompletedChallengeCellViewModel
        @State var presentChallengeAFriend = false
        @State var challengeCompletedIncrement = 0
        @State var showCompleteChallengeAlert = false
        var noLeaderboardEntries = ["first place", "second place", "third place" ]
        @State var progressValue: Float = 0.0
        
    func completeChallenge() {
            userChallengeCellVM.repository.completeAChallenge(userChallengeCellVM.userChallenge)
            challengeCompletedIncrement += 1
            self.showCompleteChallengeAlert.toggle()
            progressSetup()
            
            if (userChallengeCellVM.userChallenge.durationDays == completedChallengeCellVM.completedChallenge.timesCompleted) {
                //Full Challenge Completed
                
            } else {
                
            }
        }
    
    func progressSetup() {
        if completedChallengeCellVM.completedChallenge.timesCompleted != 0 {
            print("calculating percentage")
            print(completedChallengeCellVM.completedChallenge.timesCompleted ?? 0)
            print(userChallengeCellVM.userChallenge.durationDays)
            let timesCompleted = 100 * completedChallengeCellVM.completedChallenge.timesCompleted!
            let duration = userChallengeCellVM.userChallenge.durationDays
            print(timesCompleted)
            print(duration)
            let progress = Float((timesCompleted) / (duration))
            print(progress)
            self.progressValue = progress / 100
            
            print(progressValue)
            
        } else {
            
        }
        
    }
        var body: some View {
            ScrollView{
                VStack {
                    VStack {
                        if(completedChallengeCellVM.completedChallenge.timesCompleted == 0) {
                            Image("trophy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                            Text($userChallengeCellVM.userChallenge.title.wrappedValue)
                                .font(.title)
                            Text($userChallengeCellVM.userChallenge.description.wrappedValue)
                            Divider()
                        } else {
                            ProgressBar(progress: self.$progressValue)
                                .frame(width: 150.0, height: 150.0)
                                .padding(40.0)
                            Text($userChallengeCellVM.userChallenge.title.wrappedValue)
                                .font(.title)
                            Text($userChallengeCellVM.userChallenge.description.wrappedValue)
                        }
                        
                    }
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
                            Text("\((completedChallengeCellVM.completedChallenge.timesCompleted ?? 0) + challengeCompletedIncrement) / \(userChallengeCellVM.userChallenge.durationDays) times")
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
                        if (completedChallengeCellVM.completedChallenge.timesCompleted != 0) {
                        VStack {
                            HStack(alignment: .top) {
                                Text("History")
                                    .font(.subheadline)
                                    .bold()
                                Spacer()
                            }
                          
                            ScrollView(.horizontal){
                                HStack(alignment: .top) {
                                ForEach(completedChallengeCellVM.history, id:\.self) { historyEntry in
                                    ZStack {
                                        Rectangle().fill(Color.white).cornerRadius(10).shadow(color:.blue, radius: 6, x: 1, y: 1).frame(width: 80, height: 80)
                                        VStack {
                                            Text("\(Date(timeIntervalSince1970: historyEntry).getTodaysDate())").font(.subheadline)
                                            Text(Date(timeIntervalSince1970: historyEntry).month).font(.subheadline)
                                        }
                                                
                                    }.padding(2)
                                   
                                    
                                }
                            }
                            }
                            
                        }.padding()
                        }
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
                                        Rectangle().fill(Color.white).cornerRadius(10).shadow(color:.blue, radius: 6, x: 1, y: 1).frame(width: 80, height: 80)
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
                        if(completedChallengeCellVM.completedChallenge.timesCompleted != 0) {
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
                Alert(title: Text("Congratulation"), message: Text(""), dismissButton: .default(Text("Back to Challenge")))
                
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
