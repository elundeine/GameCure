//
//  UserCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 25.12.20.
//

import Foundation
import Combine
import FirebaseAuth

class UserCellViewModel: ObservableObject, Identifiable {
    @Published var repository : Repository

    @Published var user: User

    var id = ""

    private var cancellables = Set<AnyCancellable>()

    //indicate if challenge is completed

    @Published var completionStateIconName = ""

    
    
    init(user: User, repository: Repository) {
        self.repository = repository
        self.user = user
        print("user cell")
        $user
            .compactMap { user in
                user.uid
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        $user
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] user in
                self?.repository.updateUser(user)
            }
            .store(in: &cancellables)
    }
    
}
