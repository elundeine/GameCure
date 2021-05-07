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
import Swift

class CompletedChallengeCellViewModel: ObservableObject, Identifiable {
    @Published var repository : Repository
    
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
    
    
    func challengeCompletedThat(dayAsDouble: Double) -> Color {
        if Date(timeIntervalSince1970: dayAsDouble)>Date() {
            return .black
        } else {
            let day = Date(timeIntervalSince1970: dayAsDouble).getTodaysDate()
            let historyAsDates = history.map { Date(timeIntervalSince1970: $0).getTodaysDate()}
            
            if historyAsDates.contains(day) {
                return .green
            } else {
                if Date(timeIntervalSince1970: dayAsDouble).getTodaysDate()==Date().getTodaysDate() {
                    return .blue
                } else {
                    return .red
                }
            }
        }
    }
    
    func checkIfTodayIsLastDay() -> Bool{
        let day = Date().getTodaysDate()
        guard let lastChallengeDay = challengeDays.last else { return false }
        if (Date(timeIntervalSince1970: lastChallengeDay).getTodaysDate() == day) {
            return true
        } else {
            return false
        }
    }
    func checkIfChallengeIsOver() -> Bool{
        let day = Date().getTodaysDate()
        guard let lastChallengeDay = challengeDays.last else { return false }
        if (day > Date(timeIntervalSince1970: lastChallengeDay).getTodaysDate()) {
            return true
        } else {
            return false
        }
    }
    
    func checkIfCompletedToday() -> Bool {
        let day = Date().getTodaysDate()
        let historyAsDates = history.map { Date(timeIntervalSince1970: $0).getTodaysDate()}
        
        if historyAsDates.contains(day) {
            return true
        } else {
            return false
        }
        
    }

    
    init(completedChallenge: CompletedChallenge, repository: Repository) {
        self.completedChallenge = completedChallenge
        self.repository = repository
      
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
                let days = [1...self.completedChallenge.challengeDuration]
                    
                    for i in 0..<self.completedChallenge.challengeDuration {
                        let date = Date(timeIntervalSince1970: self.completedChallenge.firstCompleted).getDate(dayDifference: i)
                        challengeDays.append(date.timeIntervalSince1970)
                    }
                }
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
