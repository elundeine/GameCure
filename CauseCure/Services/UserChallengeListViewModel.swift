//
//  UserChallengesListViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 23.12.20.
//

import Foundation
import Combine
import FirebaseFirestoreSwift
import SwiftUI

class UserChallengeListViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
    @Published var challengeRepository = ChallengeRepository()
    @Published var userChallengeCellViewModels = [UserChallengeCellViewModel]()
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        challengeRepository.$userChallenges.map { userChallenge in
            userChallenge.map { userChallenge in
                    UserChallengeCellViewModel(userChallenge: userChallenge)
                }
            }
            .assign(to: \.userChallengeCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    
    func addChallenge(userChallenge: Challenge) {
        challengeRepository.addChallenge(userChallenge)
//        let challengeVM = ChallengeCellViewModel(challenge: challenge)
//        self.challengeCellViewModels.append(challengeVM)
    }
}
