//
//  CompletedChallengeCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.01.21.
//

import Foundation

import Foundation
import Combine
import FirebaseFirestoreSwift
import SwiftUI

class CompletedChallengeListViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
    @Published var repository : Repository
    @Published var completedChallengeCellViewModels = [CompletedChallengeCellViewModel]()
    @Published var sharedCompletedChallengeViewModels = [SharedCompletedChallengeCellViewModel]()
    @Published var friendCompletedChallengeViewModels = [SharedCompletedChallengeCellViewModel]()
    private var cancellabels = Set<AnyCancellable>()
    

    init(repository: Repository) {
        self.repository = repository
        repository.$completedUserChallenges.map { completedChallenge in
            completedChallenge.map { completedChallenge in
                CompletedChallengeCellViewModel(completedChallenge: completedChallenge, repository: repository)
                }
            }
            .assign(to: \.completedChallengeCellViewModels, on: self)
            .store(in: &cancellabels)

        repository.$sharedCompletedUserChallenges.map { sharedCompletedChallenge in
            sharedCompletedChallenge.map { sharedCompletedChallenge in
                SharedCompletedChallengeCellViewModel(completedChallenge: sharedCompletedChallenge, repository: repository)
                }
            }
            .assign(to: \.sharedCompletedChallengeViewModels, on: self)
            .store(in: &cancellabels)
        
        repository.$friendsCompletedUserChallenges.map { sharedCompletedChallenge in
            sharedCompletedChallenge.map { sharedCompletedChallenge in
                SharedCompletedChallengeCellViewModel(completedChallenge: sharedCompletedChallenge, repository: repository)
                }
            }
            .assign(to: \.friendCompletedChallengeViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    
//    func addChallenge(userChallenge: Challenge) {
//        repository.addChallenge(userChallenge)
////        let challengeVM = ChallengeCellViewModel(challenge: challenge)
////        self.challengeCellViewModels.append(challengeVM)
//    }
}
