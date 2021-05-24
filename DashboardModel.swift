//
//  DashboardModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 07.05.21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Dashboard: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userId: String
    var activeChallenges: [String]?
    var completedChallenges: [String]?
    var invites: [String]?
    
}
