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
    @ObservedObject var repository = Repository()            
    @ObservedObject var challengeListVM = ChallengeListViewModel()
    @ObservedObject var userChallengeListVM = UserChallengeListViewModel()
    @ObservedObject var categoryListVM = CategoryListViewModel()

    @State var presentAddNewItem = false
    
    @State var menuOpen: Bool = false

    
    
    func homeViewSetup() {
        listen()
    }
    func addTodayToUserLoggedInDates() {
        session.session?.loggedInDates
    }
    
    func performOnAppear() {
        listen()
    }
    func listen() {
        session.listen()
    }
    
    func openMenu() {
           self.menuOpen.toggle()
       }
    
    var body: some View {
        
        //TODO: If challenge is empty case
        ZStack{
        NavigationView {
            VStack (alignment: .leading) {
//                CustomSearchBar(challengeRepository: challengeRepository).padding(.top)
                
                MyChallengesView(userChallengeListVM: userChallengeListVM)
                    .listStyle(PlainListStyle())
            }.navigationBarItems(leading:
                       HStack {
                        Button(action:  {self.openMenu()}) {
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
                        
                           .navigationBarTitle(Text("My Dashboard"))
                   }
            
        SideMenuView(width: 270,
                        isOpen: self.menuOpen,
                        menuClose: self.openMenu)
        .onAppear(perform: performOnAppear)
        }
    }
}
enum InputError: Error {
  case empty
}


struct ProductCard: View {
    @ObservedObject var challengeCellVM: ChallengeCellViewModel
    
    var body: some View {
        HStack(alignment: .center) {
                Text("\($challengeCellVM.challenge.title.wrappedValue)")
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}


