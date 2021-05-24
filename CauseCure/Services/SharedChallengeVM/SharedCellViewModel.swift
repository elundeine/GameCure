//
//  SharedCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.05.21.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class SharedChallengeCellViewModel: ObservableObject, Identifiable {
    @Published var repository : Repository
    
    @Published var sharedChallenge: SharedActiveChallenge
    
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
    
    static func newChallenge() -> SharedChallengeCellViewModel {
        print("here")
        return SharedChallengeCellViewModel(sharedChallenge: SharedActiveChallenge(title: "", userId: "", challengeId: "", durationDays: 0, interval: "", description: "", userIds: [""], challengeCreator: "", challengedUserId: "", challengedUsername: "", challengerUserId: "", challengerUsername: ""), repository: Repository())    }
    
    static func newChallenge(title: String, challengeId: String, durationDays: Int, interval: String, searchName: [String], description: String, completed: Bool, challengeCreater: String) -> SharedChallengeCellViewModel {
        print("here")

        return SharedChallengeCellViewModel(sharedChallenge: SharedActiveChallenge(title: "", userId: "", challengeId: "", durationDays: 0, interval: "", description: "", userIds: [""], challengeCreator: "", challengedUserId: "", challengedUsername: "", challengerUserId: "", challengerUsername: ""), repository: Repository()) 
    }
    
    
    init(sharedChallenge: SharedActiveChallenge, repository: Repository) {
        self.sharedChallenge = sharedChallenge
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
        $sharedChallenge
            .compactMap { sharedChallenge in
                sharedChallenge.id
            }
            .assign(to: \.id, on: self)
            
            .store(in: &cancellables)
        $sharedChallenge
            .compactMap { sharedChallenge in
                sharedChallenge.challengeId
            }
            .assign(to: \.challengeId, on: self)
            
            .store(in: &cancellables)
        $sharedChallenge
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] sharedChallenge in
                self?.repository.updateSharedChallenge(sharedChallenge)
            }
            .store(in: &cancellables)
    }
    
}
