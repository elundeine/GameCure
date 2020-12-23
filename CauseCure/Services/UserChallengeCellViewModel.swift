//
//  UserChallengeCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 23.12.20.
//
import Foundation
import Combine
import FirebaseAuth


class UserChallengeCellViewModel: ObservableObject, Identifiable {
    @Published var challengeRepository = ChallengeRepository()
    
    @Published var userChallenge: Challenge
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    //indicate if challenge is completed
    
    @Published var completionStateIconName = ""
    
    
    static func newChallenge() -> UserChallengeCellViewModel {
        print("here")
        return UserChallengeCellViewModel(userChallenge: Challenge(title: "", category: "", durationDays: "", interval: "", searchName: [""], description: "", completed: false, challengeCreater: Auth.auth().currentUser?.uid ?? "" ))
    }
    
    static func newChallenge(title: String, durationDays: String, interval: String, searchName: [String], description: String, completed: Bool, challengeCreater: String) -> UserChallengeCellViewModel {
        print("here")
        return UserChallengeCellViewModel(userChallenge: Challenge(title: title, category: "", durationDays: durationDays, interval: interval, searchName: searchName, description: description, completed: completed, challengeCreater: challengeCreater))
    }
    
    
    
    init(userChallenge: Challenge) {
        self.userChallenge = userChallenge
        
        $userChallenge
            .map { userChallenge in
                userChallenge.completed ? "checkmark.circle.fill" : "bell.circle.fill"
            }
            .assign(to: \.completionStateIconName, on: self)
            .store(in: &cancellables)
        $userChallenge
            .compactMap { userChallenge in
                userChallenge.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        $userChallenge
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] userChallenge in
                self?.challengeRepository.updateChallenge(userChallenge)
            }
            .store(in: &cancellables)
    }
    
}
