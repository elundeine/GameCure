//
//  File.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 11.12.20.
//

import Foundation
import Combine
import FirebaseAuth

class ChallengeCellViewModel: ObservableObject, Identifiable {
    @Published var repository = Repository()
    
    @Published var challenge: Challenge
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    //indicate if challenge is completed
    
    @Published var completionStateIconName = ""
    
    
    static func newChallenge() -> ChallengeCellViewModel {
        print("here")
        return ChallengeCellViewModel(challenge: Challenge(title: "", category: "", durationDays: "", interval: "", searchName: [""], description: "", completed: false, challengeCreater: Auth.auth().currentUser?.uid ?? "" ))
    }
    
    static func newChallenge(title: String, durationDays: String, interval: String, searchName: [String], description: String, completed: Bool, challengeCreater: String) -> ChallengeCellViewModel {
        print("here")
        return ChallengeCellViewModel(challenge: Challenge(title: title, category: "", durationDays: durationDays, interval: interval, searchName: searchName, description: description, completed: completed, challengeCreater: challengeCreater))
    }
    
    
    
    init(challenge: Challenge) {
        self.challenge = challenge
        
        $challenge
            .map { challenge in
                challenge.completed ? "checkmark.circle.fill" : "bell.circle.fill"
            }
            .assign(to: \.completionStateIconName, on: self)
            .store(in: &cancellables)
        $challenge
            .compactMap { challenge in
                challenge.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        $challenge
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] challenge in
                self?.repository.updateChallenge(challenge)
            }
            .store(in: &cancellables)
    }
    
}
