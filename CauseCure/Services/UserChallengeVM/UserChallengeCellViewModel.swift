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
    @Published var repository = Repository()
    
    @Published var userChallenge: Challenge
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    //indicate if challenge is completed
    
    @Published var completionStateIconName = ""
    @Published var numberOfCompletions = 0
    @Published var userCompletions = 0
    @Published var leaderBoard = [("" , 0)]
    
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
            .map { userChallenge in
                guard let userId = Auth.auth().currentUser?.uid else { return 0 }
                let filtered = userChallenge.completedBy?.filter {$0.value == userId }
                return filtered?.count ?? 0
            }
            .assign(to: \.userCompletions, on: self)
        $userChallenge
            .map { challenge in
                var counts: [String: Int] = [:]
                guard let completedBy = userChallenge.completedBy else { return  [("" , 0)]}
                for (_, value) in completedBy {
                    counts[value] = (counts[value] ?? 0) + 1
                    
                }
                print(counts)
                let sorted = counts.sorted {
                    return $0.1 > $1.1
                }
                print(sorted)
                return sorted
            }
            .assign(to: \.leaderBoard, on: self)
        $userChallenge
            .map { userChallenge in
                userChallenge.completedBy?.count ?? 0
            }
            .assign(to: \.numberOfCompletions, on: self)
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
                self?.repository.updateChallenge(userChallenge)
            }
            .store(in: &cancellables)
    }
    
}
