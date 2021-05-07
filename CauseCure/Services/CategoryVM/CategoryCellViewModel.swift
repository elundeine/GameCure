//
//  CategoryCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 21.12.20.
//
import Foundation
import Combine
import FirebaseAuth

class CategoryCellViewModel: ObservableObject, Identifiable {
    @Published var repository : Repository
    
    @Published var category: ChallengeCategory
    
    var name = ""
    
    private var cancellables = Set<AnyCancellable>()

    
    init(category: ChallengeCategory, repository: Repository) {
        self.category = category
        self.repository = repository
        $category
            .compactMap { category in
                category.name
            }
            .assign(to: \.name, on: self)
            .store(in: &cancellables)
    }
    
}
