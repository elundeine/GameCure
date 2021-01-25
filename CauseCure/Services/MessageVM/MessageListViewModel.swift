//
//  MessageListViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 05.01.21.
//

import Foundation
import Combine
import FirebaseFirestoreSwift
import SwiftUI

class MessageListViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
    @Published var repository = Repository()
    @Published var messageCellViewModels = [MessageCellViewModel]()
    
    var userId = ""
    var receiverId = ""
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        repository.$messages.map { messages in
                messages.map { message in
                    MessageCellViewModel(message: message)
                }
            }
            .assign(to: \.messageCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
    
    func addChallenge(challenge: Challenge) {
        repository.addChallenge(challenge)
//        let challengeVM = ChallengeCellViewModel(challenge: challenge)
//        self.challengeCellViewModels.append(challengeVM)
    }
}
