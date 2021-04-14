//
//  MessageCellViewModel.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 05.01.21.
//

import Foundation
import Combine
import FirebaseAuth

//class MessageCellViewModel: ObservableObject, Identifiable {
//    
//    @Published var repository = Repository()
//    @Published var message: Message
//    
//    var id = ""
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    //indicate if challenge is completed
//    
//    
//    
//    static func newMessage() -> MessageCellViewModel {
////        print("here")
////        return MessageCellViewModel(message: Message(messageId: "", textMessage: "", profile: "", photoUrl: "", sender: "", username: "", timestamp: 0, isPhoto: false))
//    }
//    
////    static func newMessage(messageId: String, textMessage: String, profile: String, photoUrl: String, sender: String, username: String, timestamp: Double, isPhoto: Bool) -> MessageCellViewModel {
////        print("here")
////        return MessageCellViewModel(message: Message(messageId: messageId, textMessage: textMessage, profile: profile, photoUrl: photoUrl, sender: sender, username: username, timestamp: timestamp, isPhoto: isPhoto))
//    }
//    
//
//
//
//init(message: Message) {
//    self.message = message
////    $message
////        .compactMap { message in
////            message.messageId
////        }
////        .assign(to: \.id, on: self)
////        .store(in: &cancellables)
////
////    }
//
//}
//
