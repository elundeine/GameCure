//
//  SharedListViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.05.21.
//

import Foundation
import Combine
import FirebaseFirestoreSwift
import SwiftUI

class SharedChallengeListViewModel: ObservableObject {

        @EnvironmentObject var session: SessionStore
        @Published var repository : Repository
        @Published var sharedChallengeCellViewModels = [SharedChallengeCellViewModel]()
        
        private var cancellabels = Set<AnyCancellable>()
        
    init(repository: Repository) {
        self.repository = repository
            repository.$userSharedChallenges.map { sharedChallenge in
                sharedChallenge.map { sharedChallenge in
                    SharedChallengeCellViewModel(sharedChallenge: sharedChallenge, repository: repository)
                    }
                }
                .assign(to: \.sharedChallengeCellViewModels, on: self)
                .store(in: &cancellabels)
        }
        
        
        func addChallenge(userChallenge: Challenge) {
            repository.addChallenge(userChallenge)
    //        let challengeVM = ChallengeCellViewModel(challenge: challenge)
    //        self.challengeCellViewModels.append(challengeVM)
        }
    }

