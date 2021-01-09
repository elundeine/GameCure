//
//  CompletedChallengeListViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.01.21.
//
import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import SwiftUI

class CompletedChallengeCellViewModel: ObservableObject, Identifiable {
    @Published var repository = Repository()
    
    @Published var completedChallenge: CompletedChallenge
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    //indicate if challenge is completed
    
    @Published var completionStateIconName = ""
    @Published var numberOfCompletions = 0
    @Published var leaderBoard = [("" , 0)]
    @Published var leaderusername = ""
    @Published var userId = ""
    @Published var challengeId = ""
    @Published var history = [Double]()
    @Published var challengeDays = [Double]()
    
    @Published var doneToday = false
    
    
    init(completedChallenge: CompletedChallenge) {
        self.completedChallenge = completedChallenge
        
      
        $completedChallenge
            .compactMap { completedChallenge in
                completedChallenge.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        $completedChallenge
            .compactMap { completedChallenge in
                if Calendar.current.isDate(Date(), equalTo: Date(timeIntervalSince1970: self.completedChallenge.firstCompleted), toGranularity: .day) {
                    print("was completed today")
                    return true
                } else {
                    print("not completed today")
                    return false
                }
            }
            .assign(to: \.doneToday, on: self)
            .store(in: &cancellables)
        $completedChallenge
            .compactMap { completedChallenge in
                completedChallenge.completed
            }
            .assign(to: \.history, on: self)
            .store(in: &cancellables)
        $completedChallenge
            .compactMap { completedChallenge in
                var challengeDays = [Double]()
                if(self.completedChallenge.challengeDuration > 0){
                print(self.completedChallenge.challengeDuration)
                let days = [1...self.completedChallenge.challengeDuration]
                    print(days)
                var i = 0
                    days.forEach {_ in 
                    let date = Date(timeIntervalSince1970: self.completedChallenge.firstCompleted).getDate(dayDifference: i)
                    print(date)
                    challengeDays.append(date.timeIntervalSince1970)
                    
                    
                    i += 1
                }
                }
                print(challengeDays)
                return challengeDays
            }
            .assign(to: \.challengeDays, on: self)
            .store(in: &cancellables)
        $completedChallenge
            .compactMap { completedChallenge in
                completedChallenge.userId
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        $completedChallenge
            .compactMap { completedChallenge in
                completedChallenge.challengeId
            }
            .assign(to: \.challengeId, on: self)
            .store(in: &cancellables)
    }
}
extension Date
{
    var startOfDay: Date
    {
        return Calendar.current.startOfDay(for: self)
    }

    func getDate(dayDifference: Int) -> Date {
        var components = DateComponents()
        components.day = dayDifference
        return Calendar.current.date(byAdding: components, to:startOfDay)!
    }
}
