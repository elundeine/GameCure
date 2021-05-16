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
    @ObservedObject var repository: Repository
    @ObservedObject var session: SessionStore
    
//    @ObservedObject var challengeListVM = ChallengeListViewModel()
    
//    @ObservedObject var categoryListVM = CategoryListViewModel()
    
    @State var presentAddNewItem = false
    @State var isPresented = false
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
                MyChallengesView(session: session, repository: repository)
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
                       //add notification view
//                         Text("")
                        HStack {
                            Button(action:  {
                                withAnimation{
                                    self.isPresented.toggle()
                                }
                            }) {
                                Image(systemName: "plus")

                            }.foregroundColor(Color.black)
                        }
                       )
            .fullScreenCover(isPresented: $isPresented) { PendingInvitationModalView(repository: repository, session: session)}
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
struct PendingInvitationModalView: View {
        @ObservedObject var repository: Repository
        @ObservedObject var session: SessionStore
            @Environment(\.presentationMode) var presentationMode
            var body: some View {
                //TODO: add dismiss button
                VStack{
                HStack {
                    Spacer()
                    Image(systemName: "xmark").onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                    
                }
                    AddCreateChallenge(session: session, repository: repository)
                
                
            }
        }
}
struct UserChallengeInviteCard: View {
    @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
    @State var invitedBy = ""
    var body: some View {
        HStack(alignment: .center) {
        Image("trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .padding(.all, 20)
        
        VStack(alignment: .leading) {
                Text("\($userChallengeCellVM.userChallenge.title.wrappedValue)")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text("Invited by \(self.invitedBy)")
                    
//                HStack {
//                    Text("daily")
//                    .font(.system(size: 16, weight: .bold, design: .default))
//                    .foregroundColor(.white)
//                    .padding(.top, 8)
//                }
        }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.red)
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}

struct ChallengeInviteCard: View {
    @ObservedObject var inviteCellVM: InviteCellViewModel
   
    @State var invitedBy = ""
    var body: some View {
        HStack(alignment: .center) {
        Image("trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .padding(.all, 20)
        
        VStack(alignment: .leading) {
                Text("\($inviteCellVM.invite.challengeTitle.wrappedValue)")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
            Text("Challenged by \($inviteCellVM.invite.challengerUsername.wrappedValue)")
                    
//                HStack {
//                    Text("daily")
//                    .font(.system(size: 16, weight: .bold, design: .default))
//                    .foregroundColor(.white)
//                    .padding(.top, 8)
//                }
        }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.blue)
        .modifier(CardModifier())
        .padding(.all, 10)
    }
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


