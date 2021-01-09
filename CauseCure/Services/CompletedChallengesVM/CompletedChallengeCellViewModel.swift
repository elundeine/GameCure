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
    @Published var repository = Repository()
    @Published var completedChallengeCellViewModels = [CompletedChallengeCellViewModel]()
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        repository.$completedUserChallenges.map { completedChallenge in
            completedChallenge.map { completedChallenge in
                CompletedChallengeCellViewModel(completedChallenge: completedChallenge)
                }
            }
            .assign(to: \.completedChallengeCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    
//    func addChallenge(userChallenge: Challenge) {
//        repository.addChallenge(userChallenge)
////        let challengeVM = ChallengeCellViewModel(challenge: challenge)
////        self.challengeCellViewModels.append(challengeVM)
//    }
}
