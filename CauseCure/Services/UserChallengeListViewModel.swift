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

class ChallengeListViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
    @Published var challengeRepository = ChallengeRepository()
    @Published var userChallengeCellViewModels = [UserChallengeCellViewModel]()
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        challengeRepository.$userChallenges.map { userChallenges in
            userChallenges.map { userChallenges in
                    ChallengeCellViewModel(userChallenges: userChallenges)
                }
            }
            .assign(to: \.challengeCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    
    func addChallenge(challenge: Challenge) {
        challengeRepository.addChallenge(challenge)
//        let challengeVM = ChallengeCellViewModel(challenge: challenge)
//        self.challengeCellViewModels.append(challengeVM)
    }
}
