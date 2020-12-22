//
//  CategoryListViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 21.12.20.
//

import Foundation
import Combine
import FirebaseFirestoreSwift
import SwiftUI

class CategoryListViewModel: ObservableObject {
    //@EnvironmentObject var session: SessionStore
    @Published var challengeRepository = ChallengeRepository()
    @Published var categoryCellViewModels = [CategoryCellViewModel]()
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        challengeRepository.$challengeCategories.map { categories in
                categories.map { category in
                    CategoryCellViewModel(category: category)
                }
            }
            .assign(to: \.categoryCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
}
