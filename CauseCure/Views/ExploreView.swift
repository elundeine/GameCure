//
//  ExploreView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 25.12.20.
//

import SwiftUI

struct ExploreView: View {

    @ObservedObject var session: SessionStore
    @ObservedObject var repository: Repository

    @StateObject var categoryListVM : CategoryListViewModel
    
    @State var isPresented = false
    @State var menuOpen = false

    init(session: SessionStore, repository: Repository) {
        self.session = session
        self.repository = repository
        _categoryListVM = StateObject(wrappedValue: CategoryListViewModel(repository: repository))
    }
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                List {
                    ForEach(categoryListVM.categoryCellViewModels) { categoryCellVM in
                        ZStack{
                            NavigationLink(destination: CategoryCell(session: session, categoryCellVM: categoryCellVM)) {
                                EmptyView()
                            }.opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                            CategoryCard(categoryCellVM: categoryCellVM)
                        }
                    }
                } .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Explore")
            .navigationBarItems(trailing:
                HStack {
                    Button(action:  {
                        withAnimation{
                            self.isPresented.toggle()
                        }
                        }) {
                            Image(systemName: "magnifyingglass")
                        
                    }.foregroundColor(Color.black)
                }
            )
        }.fullScreenCover(isPresented: $isPresented) { FullScreenSearchModalView(session: session)
        }
        
    }
}

struct FullScreenSearchModalView: View {
        @ObservedObject var session : SessionStore
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
                Text("Search for challenges").font(.title)
                CustomSearchBar(session: session)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
            }
           Spacer()
            
        }
    }

struct CategoryCell: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var categoryCellVM: CategoryCellViewModel
    @ObservedObject var challengeListVM = ChallengeListViewModel()
    var body: some View {
        //TODO: If challenge is empty case
        ZStack{
            Text("hello")
            
                VStack (alignment: .leading) {
                    List {
                        ForEach(challengeListVM.challengeCellViewModels.filter { categoryCellVM.category.challenges.keys.contains($0.challenge.id!)}) { challengeCellVM in
                            NavigationLink(destination: ChallengeCellDetail(session: session, challengeCellVM: challengeCellVM, myChallenge: challengeCellVM.repository.checkIfIDoThe(challengeCellVM.challenge))) {
                                ChallengeCard(challengeCellVM: challengeCellVM)
                                }
                        }
                    //
                    }.listStyle(PlainListStyle())
                }
            
        }
    }
}
struct CategoryCard: View {
    @ObservedObject var categoryCellVM: CategoryCellViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            
            Image("\($categoryCellVM.category.name.wrappedValue)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.all, 20)

            VStack(alignment: .leading) {
                Text("\($categoryCellVM.category.name.wrappedValue)")
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                HStack {
                    Text("Challenges")
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
struct ChallengeCard: View {
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
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
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
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}

//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}
