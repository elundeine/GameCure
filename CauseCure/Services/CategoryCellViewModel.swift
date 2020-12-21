//
//  CategoryCellViewModel.swift
//  CauseCure
//
//  Created by Oscar Lange on 12/21/20.
//

import Foundation
import Combine
import FirebaseAuth

class CategorCellViewModel: ObservableObject, Identifiable {
    @Published var challengeRepository = ChallengeRepository()
    
    @Published var category: ChallengeCategory
    
    var name = ""
    
    private var cancellables = Set<AnyCancellable>()

    
    init(category: ChallengeCategory) {
        self.category = category
        $category
            .compactMap { category in
                category.name
            }
            .assign(to: \.name, on: self)
            .store(in: &cancellables)
    }
    
}
