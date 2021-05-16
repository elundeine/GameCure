//
//  FriendListViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 04.01.21.
//

import Foundation
import Combine
import FirebaseFirestoreSwift
import SwiftUI



//NOT USED ATM
class FollowerListViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
    @Published var repository : Repository
    @Published var followerCellViewModels = [FollowerCellViewModel]()
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init(repository: Repository) {
        self.repository = repository
        repository.$following.map { follow in
                follow.map { follow in
                    FollowerCellViewModel(follow: follow, repository: repository)
                }
            }
            .assign(to: \.followerCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    
//    func addChallenge(challenge: Challenge) {
//        repository.addChallenge(challenge)
////        let challengeVM = ChallengeCellViewModel(challenge: challenge)
////        self.challengeCellViewModels.append(challengeVM)
//    }
}
