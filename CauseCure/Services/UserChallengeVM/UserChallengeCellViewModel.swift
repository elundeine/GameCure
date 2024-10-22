//
//  UserChallengeCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 23.12.20.
//
import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class UserChallengeCellViewModel: ObservableObject, Identifiable {

    @Published var repository : Repository
    
    @Published var userChallenge: ActiveChallenge
    
    var id = ""
    var challengeId = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    //indicate if challenge is completed
    
    @Published var completionStateIconName = ""
    @Published var numberOfCompletions = 0
    @Published var userCompletions = 0
    @Published var leaderBoard = [("" , 0)]
    @Published var leaderusername = ""
    @Published var history = [Date]()
    @Published var userId = ""
    
    static func newChallenge() -> UserChallengeCellViewModel {
        print("here")

        return UserChallengeCellViewModel(userChallenge: ActiveChallenge(title: "", challengeId: "", durationDays: 0, interval: "", description: "", completed: false, challengeCreater: "", userId: ""), repository: Repository())

    }
    
    static func newChallenge(title: String, challengeId: String, durationDays: Int, interval: String, searchName: [String], description: String, completed: Bool, challengeCreater: String) -> UserChallengeCellViewModel {
        print("here")


        return UserChallengeCellViewModel(userChallenge: ActiveChallenge(title: title, challengeId: challengeId, durationDays: durationDays, interval: interval, description: description, completed: completed, challengeCreater: challengeCreater, userId: challengeCreater), repository: Repository())

    }
    
    func getUsernameFor (id : String) -> String {
    
        return repository.getUsernameBy(id)
        
    }
    
    

    init(userChallenge: ActiveChallenge, repository: Repository) {
        self.userChallenge = userChallenge
        self.repository = repository
        

        
//        $userChallenge
//            .map { userChallenge in

//                guard let userId = Auth.auth().currentUser?.uid else { return 0 }
////                self.repository.
//                let filtered = completedBy.filter {$0.key == userId }
//                print(filtered)
//                for (_, value) in filtered {
//                    let timestamp = TimeInterval(value)
//                    print("timestamp:")
//                    self.history.append(Date(timeIntervalSince1970: timestamp ?? 0.0))
//                }
//                print("history")
//                print(self.history)
//                print("count")
//                print(self.history.count)
//                return filtered.count
//                return 1
//            }
//            .assign(to: \.userCompletions, on: self)
//        $userChallenge
//            .map { challenge in
//                var counts: [String: Int] = [:]
//                guard let completedBy = userChallenge.completedBy else { return  [("" , 0)]}
//                for (key, _) in completedBy {
//                    counts[key] = (counts[key] ?? 0) + 1
//                    
//                }
////                let filtered = userChallenge.completedBy?.filter {$0.value == userId }
//                let sorted = counts.sorted {
//                    return $0.1 > $1.1
//                }
////                print(counts)
//                self.leaderusername = self.repository.getUsernameBy(sorted.first?.0 ?? "No first place, be the first!")
////                print(self.leaderusername)
//                return sorted
//            }
//            .assign(to: \.leaderBoard, on: self)
//        $userChallenge
//            .map { userChallenge in
//                userChallenge.completedBy?.count ?? 0
//            }
//            .assign(to: \.numberOfCompletions, on: self)
        $userChallenge
            .compactMap { userChallenge in
                userChallenge.id
            }
            .assign(to: \.id, on: self)
            
            .store(in: &cancellables)
        $userChallenge
            .compactMap { userChallenge in
                userChallenge.challengeId
            }
            .assign(to: \.challengeId, on: self)
            
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
