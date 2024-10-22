//
//  MyChallengesView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 22.12.20.
//

import SwiftUI

struct MyChallengesView: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var repository: Repository
    @StateObject var userChallengeListVM : UserChallengeListViewModel
    @StateObject var inviteListVM : InviteListViewModel
    @StateObject var sharedListVM : SharedChallengeListViewModel
    @StateObject var completedChallengeListVM : CompletedChallengeListViewModel
    @AppStorage("selectedTab") private var selectedTab = "house.fill"
    
    @Binding var isPresented : Bool
    init(session: SessionStore, repository: Repository, isPresented: Binding<Bool>) {
        self.session = session
        self.repository = repository
        _userChallengeListVM = StateObject(wrappedValue: UserChallengeListViewModel(repository: repository))
        _inviteListVM = StateObject(wrappedValue: InviteListViewModel(repository: repository))
        _sharedListVM = StateObject(wrappedValue: SharedChallengeListViewModel(repository: repository))
        _completedChallengeListVM = StateObject(wrappedValue: CompletedChallengeListViewModel(repository: repository))
        self._isPresented = isPresented
    }


    func headerView(type: String) -> some View{
        return HStack {
            Text("\(type)")
            Spacer()
        }.padding(.trailing, 20).font(.subheadline)
    }

    var body: some View {
        if(userChallengeListVM.userChallengeCellViewModels.isEmpty && inviteListVM.repository.invites.isEmpty && sharedListVM.sharedChallengeCellViewModels.isEmpty) {
            HStack() {
                Spacer()
                VStack(){
                    Spacer()
                    Text("You have no Challenges!")
                        .font(Font.title.bold().lowercaseSmallCaps())
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                        selectedTab = "magnifyingglass"
                    }) {
                        Text("Browse Challenges")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                    Button(action: {
                        self.isPresented = true
                    }) {
                        Text("Create a Challenge")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                }
                Spacer()
            }
        }
        
        List {
            if(inviteListVM.invites.isEmpty == false) {
                ForEach(inviteListVM.invites) { invite in
                    ZStack{
                        NavigationLink(destination: InvitedSharedChallengeView(session: session, inviteCellVM: invite)) {
                            EmptyView()
                        }   .opacity(0.0)
                        .buttonStyle(PlainButtonStyle())
                        ChallengeInviteCard(inviteCellVM: invite)
                    }
                }
            }
            ForEach(userChallengeListVM.userChallengeCellViewModels) { userChallengeCellVM in
                ZStack{
                    NavigationLink(destination: UserChallengeCellDetail(session: session, repository: repository, userChallengeCellVM: userChallengeCellVM, completedChallengeCellVM: completedChallengeListVM.completedChallengeCellViewModels.first(where: {$0.challengeId ==   userChallengeCellVM.challengeId }) ?? CompletedChallengeCellViewModel(completedChallenge: CompletedChallenge(id: "", challengeId: "", userId: "", username: session.session?.username ?? "", completed: [0], timesCompleted: 0,firstCompleted: 0.0, challengeDuration: 0), repository: repository))) {
                        
                        EmptyView()
                    }.opacity(0.0)
                    .buttonStyle(PlainButtonStyle())
                    UserChallengeCard(userChallengeCellVM: userChallengeCellVM)
                }
            }
            ForEach(sharedListVM.sharedChallengeCellViewModels) { sharedChallengeCellVM in
                ZStack{
                    NavigationLink(destination: SharedChallengeCellDetailView(session: session, repository: repository, sharedChallengeCellVM: sharedChallengeCellVM, completedChallengeCellVM: completedChallengeListVM.sharedCompletedChallengeViewModels.first(where: { $0.challengeId == sharedChallengeCellVM.sharedChallenge.challengeId}) ?? SharedCompletedChallengeCellViewModel(completedChallenge: SharedCompletedChallenge(challengeId: "", userId: "", completed: [0], timesCompleted: 0, firstCompleted: 0, challengeDuration: 0, sharedChallengeId: "", sharedWithId: "", username: ""), repository: repository), sharedCompletedChallengeCellVM: completedChallengeListVM.friendCompletedChallengeViewModels.first(where: {$0.challengeId == sharedChallengeCellVM.sharedChallenge.challengeId}) ?? SharedCompletedChallengeCellViewModel(completedChallenge: SharedCompletedChallenge(challengeId: "", userId: "", completed: [0], timesCompleted: 0, firstCompleted: 0, challengeDuration: 0, sharedChallengeId: "", sharedWithId: "", username: ""), repository: repository))){
                        EmptyView()
                    }.opacity(0.0)
                    .buttonStyle(PlainButtonStyle())
                    SharedChallengeCard(sharedChallengeCellVM: sharedChallengeCellVM)
                }
            }
            
        }
    }
}
struct SharedUserChallengeCard: View {
    @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
    @ObservedObject var completedChallengeCellVM: CompletedChallengeCellViewModel
    @ObservedObject var sharedCompletedChallengeCellVM: CompletedChallengeCellViewModel
    @State var timesCompleted = 0
    @State var sharedTimesCompleted = 0
    @State var progressValue: Float = 0.0
    @State var sharedProgressValue: Float = 0.0
    @State var doneToday = false
    @State var sharedDoneToday = false
    
    func progressSetup() {
        if (completedChallengeCellVM.checkIfChallengeIsOver() == false) {
            if completedChallengeCellVM.completedChallenge.timesCompleted != 0 {
                let timesCompletedTemp = 100 * completedChallengeCellVM.completedChallenge.timesCompleted!
                self.timesCompleted = timesCompletedTemp / 100
                let duration = userChallengeCellVM.userChallenge.durationDays
                let progress = Float((timesCompletedTemp) / (duration))
                self.progressValue = progress / 100
                self.doneToday = completedChallengeCellVM.checkIfCompletedToday()
            }
            if sharedCompletedChallengeCellVM.completedChallenge.timesCompleted != 0 {
                let timesCompletedTemp = 100 * sharedCompletedChallengeCellVM.completedChallenge.timesCompleted!
                self.timesCompleted = timesCompletedTemp / 100
                let duration = userChallengeCellVM.userChallenge.durationDays
                let progress = Float((timesCompletedTemp) / (duration))
                self.sharedProgressValue = progress / 100
                self.sharedDoneToday = sharedCompletedChallengeCellVM.checkIfCompletedToday()
            }
            
        } else {
           
            
        }
        
    }
   
    var body: some View {
        VStack {
        HStack(alignment: .center) {
        Image("trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .padding(.all, 20)
        
        VStack(alignment: .leading) {
                Text("\($userChallengeCellVM.userChallenge.title.wrappedValue)")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
                HStack {
                    Text("with Hannah")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                }
        }.padding(.trailing, 20)
            Spacer()
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.blue)
        .modifier(CardModifier())
        .padding(.all, 10)
    
        }
    }
}

struct UserChallengeCard: View {
    @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
    
    
    var body: some View {
        HStack(alignment: .center) {
        Image("trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .padding(.all, 20)
        
        VStack(alignment: .leading) {
                Text("\($userChallengeCellVM.userChallenge.title.wrappedValue)")
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
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}

struct SharedChallengeCard: View {
    @ObservedObject var sharedChallengeCellVM: SharedChallengeCellViewModel
    
    
    var body: some View {
        HStack(alignment: .center) {
        Image("trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .padding(.all, 20)
        
        VStack(alignment: .leading) {
                Text("\($sharedChallengeCellVM.sharedChallenge.title.wrappedValue)")
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
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}


//struct MyChallengesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyChallengesView()
//    }
//}
