//
//  ExploreView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 25.12.20.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var repository = Repository()
    @ObservedObject var categoryListVM = CategoryListViewModel()
    @State var isPresented = false
    @State var menuOpen = false
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                List {
                    ForEach(categoryListVM.categoryCellViewModels) { categoryCellVM in
                        ZStack{
                            NavigationLink(destination: CategoryCell(categoryCellVM: categoryCellVM)) {
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
        }.fullScreenCover(isPresented: $isPresented) { FullScreenSearchModalView(repository: repository)
        }
        
    }
}

struct FullScreenSearchModalView: View {
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var repository = Repository()
        var body: some View {
            //TODO: add dismiss button
            VStack{
            HStack {
                Spacer()
                Text("Dismiss").onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }.padding()
                
            }
            CustomSearchBar(repository: repository)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
            }
           Spacer()
            
        }
    }

struct CategoryCell: View {
    @ObservedObject var categoryCellVM: CategoryCellViewModel
    @ObservedObject var challengeListVM = ChallengeListViewModel()
    var body: some View {
        //TODO: If challenge is empty case
        ZStack{
            Text("hello")
            
                VStack (alignment: .leading) {
                    List {
                        ForEach(challengeListVM.challengeCellViewModels.filter { categoryCellVM.category.challenges.keys.contains($0.challenge.id!)}) { challengeCellVM in
                           NavigationLink(destination: ChallengeCellDetail(challengeCellVM: challengeCellVM, myChallenge: true)) {
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
