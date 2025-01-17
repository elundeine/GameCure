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

    @Published var repository : Repository

    @Published var userChallengeCellViewModels = [UserChallengeCellViewModel]()
   
    
    private var cancellabels = Set<AnyCancellable>()
    

    init(repository: Repository) {

        self.repository = repository
        repository.$userChallenges.map { userChallenge in
            userChallenge.map { userChallenge in
                UserChallengeCellViewModel(userChallenge: userChallenge, repository: repository)
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
