//
//  UserListViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 25.12.20.
//
import Foundation
import Combine
import FirebaseFirestoreSwift
import SwiftUI

class UserListViewModel: ObservableObject {
    
    @EnvironmentObject var session: SessionStore
    @Published var repository : Repository
    @Published var userCellViewModels = [UserCellViewModel]()


    private var cancellabels = Set<AnyCancellable>()

    init(repository: Repository) {
        self.repository = repository
        repository.$users.map { user in
            user.map { user in
                UserCellViewModel(user: user)
            }
        }
        .assign(to: \.userCellViewModels, on: self)
        .store(in: &cancellabels)
    }
}


//func addChallenge(userChallenge: Challenge) {
//    challengeRepository.addChallenge(userChallenge)
////        let challengeVM = ChallengeCellViewModel(challenge: challenge)
////        self.challengeCellViewModels.append(challengeVM)
//}
