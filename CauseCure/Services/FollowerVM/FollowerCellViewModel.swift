//
//  FriendCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 04.01.21.
//

import Foundation
import Combine
import FirebaseAuth


//NOT USED ATM
class FollowerCellViewModel: ObservableObject, Identifiable {
    @Published var repository = Repository()
    
    @Published var follow: User
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()

    
    init(follow: User) {
        self.follow = follow
        $follow
            .compactMap { follow in
                follow.uid
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
}
