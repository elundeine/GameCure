//
//  ChallengeListViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 11.12.20.
//

import Foundation
import Combine
import FirebaseFirestoreSwift
import SwiftUI

class ChallengeListViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
    @Published var repository = ChallengeService()
    @Published var challengeCellViewModels = [ChallengeCellViewModel]()
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        repository.$challenges.map { challenges in
                challenges.map { challenge in
                    ChallengeCellViewModel(challenge: challenge)
                }
            }
            .assign(to: \.challengeCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    func addChallenge(challenge: Challenge) {
        repository.addChallenge(challenge)
//        let challengeVM = ChallengeCellViewModel(challenge: challenge)
//        self.challengeCellViewModels.append(challengeVM)
    }
}
