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
        @ObservedObject var userListVM = UserListViewModel()
        var body: some View {
            //TODO: add dismiss button
            HStack {
                Spacer()
                Text("Dismiss").onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            CustomSearchBar(repository: repository)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
        }
    }

//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}
