//
//  HomeView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//


import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import SwiftUI
import SDWebImageSwiftUI



struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var challengeListVM = ChallengeListViewModel()
//    @ObservedObject var userModel = UserRepository()
    @State var presentAddNewItem = false
    
    @State var presentProfilOverview = false
    
    
    func homeViewSetup() {
        listen()
    }
    func addTodayToUserLoggedInDates() {
        session.session?.loggedInDates
    }
    
    func listen() {
        session.listen()
    }
    
    
    var body: some View {
        
        //TODO: If challenge is empty case
        
        NavigationView {
            VStack (alignment: .leading) {
                List {
                    ForEach(challengeListVM.challengeCellViewModels) { challengeCellVM in
                        NavigationLink(destination: ChallengeCellDetail(challengeCellVM: challengeCellVM)) {
                            ProductCard(challengeCellVM: challengeCellVM)
                        }
                    }
                    
                //new list entry to add a challenge
                    if presentAddNewItem {
                        ChallengeCell(challengeCellVM: ChallengeCellViewModel.newChallenge()) { result in
                            if case .success(let challenge) = result {
                                print("success")
                              self.challengeListVM.addChallenge(challenge: challenge)
                            }
                            self.presentAddNewItem.toggle()
                          }
                        
                    }
                }.listStyle(PlainListStyle())
                    
                    
                // Add new Challenge Button
//                Button(action: { self.presentAddNewItem.toggle()
//                    print("toggled")
//                }) {
//                    HStack {
//                        Image(systemName: "plus.circle.fill")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                    Text("Add new Challenge")
//                    }
//                }.padding()
            }.navigationBarItems(leading:
                       HStack {
                        Button(action:  {self.presentProfilOverview.toggle()}) {
                            if session.session?.profileImageUrl != nil {
                                WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                                   .resizable().clipShape(Circle())
                                   .frame(width: 30, height: 30)
                                   .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            } else {
                                Image(systemName: "person.fill").resizable()
                                    .frame(width: 25, height: 25)
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            }
                        }
                       }, trailing:
                       //add further nav bar button
                        HStack {
                           Text("")
                       })
                        
                           .navigationBarTitle(Text("Challenges"))
                   } .onAppear(perform: listen)
        
    }
}
enum InputError: Error {
  case empty
}

struct ChallengeCell: View {
    @ObservedObject var challengeCellVM: ChallengeCellViewModel

    var onCommit: (Result<Challenge, InputError>) -> Void = {_ in }

        var body: some View {
            HStack{
                Image(systemName: challengeCellVM.completionStateIconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                      self.challengeCellVM.challenge.completed.toggle()
                    }
                TextField("Enter the challenges title", text: $challengeCellVM.challenge.title, onCommit: {
                    if !self.challengeCellVM.challenge.title.isEmpty {
                      self.onCommit(.success(self.challengeCellVM.challenge))
                    }
                    else {
                      self.onCommit(.failure(.empty))
                    }
        }).id(challengeCellVM.id)
      }
    }
}


struct ProductCard: View {
    @ObservedObject var challengeCellVM: ChallengeCellViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Image("trophy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.all, 20)
            
            VStack(alignment: .leading) {
                Text("\($challengeCellVM.challenge.title.wrappedValue)")
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text("\($challengeCellVM.challenge.description.wrappedValue)")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.gray)
                HStack {
                    Text("daily")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}


struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}

