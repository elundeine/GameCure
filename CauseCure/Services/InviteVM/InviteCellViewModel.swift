//
//  InviteCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.05.21.
//

import Foundation
import Combine

class InviteCellViewModel: ObservableObject, Identifiable {
    @Published var repository = Repository()
    
    @Published var invite: Invite
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    //indicate if challenge is completed
    
    @Published var completionStateIconName = ""
    @Published var numberOfCompletions = 0
    @Published var userCompletions = 0
    @Published var leaderBoard = [("" , 0)]
    @Published var leaderusername = ""
    @Published var history = [Date]()
    @Published var userId = ""
    
    static func newInvite() -> InviteCellViewModel {
        print("here")
        return InviteCellViewModel(invite: Invite(challengedUserId: "", challengerUserId: "", challengerUsername: "", challengeId: "", challengeTitle: "", challengeDescription: "", durationDays: 0, shared: false))
    }
    
    static func newInvite( challengedUserId: String, challengerUserId: String, challengerUsername: String, challengeId: String, challengeTitle: String, challengeDescription: String, durationDays: Int, shared: Bool) -> Invite {
        print("here")
        return Invite(challengedUserId: challengedUserId, challengerUserId: challengerUserId, challengerUsername: challengerUsername, challengeId: challengeId, challengeTitle: challengeTitle, challengeDescription: challengeDescription, durationDays: durationDays, shared: shared)    }
    
    func getUsernameFor (id : String) -> String {
    
        return repository.getUsernameBy(id)
        
    }
    
    
    init(invite: Invite) {
        self.invite = invite
        
        $invite
            .map { invite in
                (invite.id ?? "")
            }
            .assign(to: \.completionStateIconName, on: self)
            .store(in: &cancellables)
        
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
    }
    
}
