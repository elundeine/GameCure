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
    @Published var repository = Repository()
    @Published var userChallengeCellViewModels = [UserChallengeCellViewModel]()
    @Published var userChallengeInvites = [UserChallengeCellViewModel]()
    @Published var userSharedChallengeInvites = [UserChallengeCellViewModel]()
    @Published var userSharedChallengeCellViewModels = [UserChallengeCellViewModel]()
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        repository.$userChallenges.map { userChallenge in
            userChallenge.map { userChallenge in
                    UserChallengeCellViewModel(userChallenge: userChallenge)
                }
            }
            .assign(to: \.userChallengeCellViewModels, on: self)
            .store(in: &cancellabels)
        
            repository.$userChallengeInvites.map { userChallenge in
            userChallenge.map { userChallenge in
                    UserChallengeCellViewModel(userChallenge: userChallenge)
                }
            }
            .assign(to: \.userChallengeInvites, on: self)
            .store(in: &cancellabels)
        
            repository.$userSharedChallengeInvites.map { userChallenge in
            userChallenge.map { userChallenge in
                    UserChallengeCellViewModel(userChallenge: userChallenge)
                }
            }
            .assign(to: \.userSharedChallengeInvites, on: self)
            .store(in: &cancellabels)
            repository.$userSharedChallenges.map { userChallenge in
            userChallenge.map { userChallenge in
                    UserChallengeCellViewModel(userChallenge: userChallenge)
                }
            }
            .assign(to: \.userSharedChallengeCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    
    func addChallenge(userChallenge: Challenge) {
        repository.addChallenge(userChallenge)
//        let challengeVM = ChallengeCellViewModel(challenge: challenge)
//        self.challengeCellViewModels.append(challengeVM)
    }
}
