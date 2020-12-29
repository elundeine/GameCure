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
    @Published var numberOfCompletions = 0
    @Published var leaderBoard = ["" , 0]
    
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
            .map { challenge in
                var counts: [String: Int] = [:]
                guard let completedBy = challenge.completedBy else { return  ["" , 0]}
                for (_, value) in completedBy {
                    counts[value] = (counts[value] ?? 0) + 1
                    
                }
                print(counts)
                print("first entry of counts")
                print(counts.first?.value)
                let sorted = counts.sorted {
                    return $0.1 > $1.1
                }
                
                print(sorted)
                return sorted
            }
            .assign(to: \.leaderBoard, on: self)
        
//        $userChallenge
//            .map { userChallenge in
//                guard let userId = Auth.auth().currentUser?.uid else { return 0 }
//                let filtered = userChallenge.completedBy?.filter {$0.value == userId }
//                return filtered?.count ?? 0
//            }
//            .assign(to: \.userCompletions, on: self)
        
        $challenge
            .map { challenge in
                challenge.completedBy?.count ?? 0
            }
            .assign(to: \.numberOfCompletions, on: self)
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

