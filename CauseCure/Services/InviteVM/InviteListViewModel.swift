//
//  InviteViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.05.21.
//

import Foundation
import Combine
import SwiftUI

class InviteListViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
//    @Published var repository = Repository()
    @Published var repository : Repository
    @Published var invites = [InviteCellViewModel]()
    
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init(repository: Repository) {
        self.repository = repository
        repository.$invites.map { invite in
            invite.map { invite in
                InviteCellViewModel(invite: invite)
                }
            }
            .assign(to: \.invites, on: self)
            .store(in: &cancellabels)
    }

}
