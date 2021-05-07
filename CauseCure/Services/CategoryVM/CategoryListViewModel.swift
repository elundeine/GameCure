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
    @Published var repository : Repository
    @Published var categoryCellViewModels = [CategoryCellViewModel]()
    
    
    private var cancellabels = Set<AnyCancellable>()
    
    init(repository: Repository){
        self.repository = repository
        repository.$challengeCategories.map { categories in
                categories.map { category in
                    CategoryCellViewModel(category: category, repository: repository)
                }
            }
            .assign(to: \.categoryCellViewModels, on: self)
            .store(in: &cancellabels)
    }
    
}
