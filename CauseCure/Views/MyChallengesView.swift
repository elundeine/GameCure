//
//  MyChallengesView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 22.12.20.
//

import SwiftUI

struct MyChallengesView: View {
    @ObservedObject var userChallengeListVM : UserChallengeListViewModel
    var body: some View {
        Text("")
        List {
            ForEach(userChallengeListVM.userChallengeCellViewModels) { userChallengeCellVM in
               NavigationLink(destination: UserChallengeCellDetail(userChallengeCellVM: userChallengeCellVM)) {
                   UserChallengeCard(userChallengeCellVM: userChallengeCellVM)
                                   }
        }
        }
    }
}

//struct MyChallengesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyChallengesView()
//    }
//}
