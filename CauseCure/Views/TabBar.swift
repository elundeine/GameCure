//
//  TabBar.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI


struct TabBar: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sharedInt: SharedInt
    //@EnvironmentObject var model: Model
    
    var body: some View {
            VStack{
                CustomTabView().environmentObject(SessionStore())

            }
    }
    
}

var tabs = ["house.fill","magnifyingglass","plus.circle.fill","message.fill","person.3.fill"]

private enum Tab: String, Equatable, CaseIterable{
    case first = "house.fill"
    case second = "magnifyingglass"
    case third = "plus"
    case fourth = "message.fill"
    case fifth = "person.3.fill"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }

}
struct CustomTabView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sharedInt: SharedInt
    
    @State private var selectedTab = "house.fill"
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedTab) {
                HomeView().environmentObject(SessionStore())
                    .tag("house.fill")
                ExploreView().environmentObject(SessionStore())
                    .environmentObject(SharedInt())
                    .tag("magnifyingglass")
                AddCreateChallenge()
                    .tag("plus.circle.fill")
                Chat()
                    .tag("message.fill")
                Community()
                    .tag("person.3.fill")
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self){
                    image in
                    TabButton(image: image, selectedTab: $selectedTab)
                    
                    if image != tabs.last {
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .padding(.bottom, edge!.bottom == 0 ? 20: 0)
        }
        .ignoresSafeArea(.keyboard, edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
        .background(Color.black.opacity(0.05).ignoresSafeArea(.all, edges: .all))
    }
}


struct TabButton: View {
    var image: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {selectedTab = image}) {
            Image(systemName: "\(image)")
                    .foregroundColor(selectedTab == image ? Color.gray: Color.black)
                    .padding()
            }
    }
    
}
