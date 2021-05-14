//
//  InviteViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.05.21.
//

import Foundation
class InviteListViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
//    @Published var repository = Repository()
    @Published var repository = Repository()
    @Published var invites = [InviteCellViewModel]()
    
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        repository.$invites.map { invite in
            invite.map { invite in
                InviteCellViewModel(invite: invite)
                }
            }
            .assign(to: \.userChallengeCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    
    func addChallenge(userChallenge: Challenge) {
        repository.addChallenge(userChallenge)
//        let challengeVM = ChallengeCellViewModel(challenge: challenge)
//        self.challengeCellViewModels.append(challengeVM)
    }
}
