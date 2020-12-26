//
//  Chat.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct Chat: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var repository = Repository()
    //TODO:
    
    //1 user cell
    
    
    //2 search
    
    //3 
    
    var body: some View {
        VStack {
            UserSearch(repository: repository)
            ForEach(repository.users) { user in
                Text(user.username)
            
            }
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
    }
}
