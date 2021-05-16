//
//  TabBar.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI


struct TabBar: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var repository = Repository()
    //@EnvironmentObject var model: Model
    @AppStorage("needsOnboarding") private var needsOnboarding: Bool = true
//    @State private var needsOnboarding = true
    
    func onAppear() {
        UITableView.appearance().backgroundColor = .white
    }
    var body: some View {
            VStack{
                CustomTabView(session: session, repository: repository)
            }
            .onAppear(perform: onAppear)
            .sheet(isPresented: $needsOnboarding){
                OnboardingView()
            }
    }
    
}

var tabs = ["house.fill","magnifyingglass","gamecontroller.fill","message.fill","person.3.fill"]

private enum Tab: String, Equatable, CaseIterable{
    case first = "house.fill"
    case second = "magnifyingglass"
    case third = "gamecontroller.fill"
    case fourth = "message.fill"
    case fifth = "person.3.fill"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }

}
struct CustomTabView: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var repository : Repository
    @AppStorage("selectedTab") private var selectedTab = "house.fill"
    //@State private var selectedTab = "house.fill"
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
                HomeView(repository: repository, session: session)
                    .tag("house.fill")
                ExploreView(session: session, repository: repository)
                    .tag("magnifyingglass")
                PaymentCheck()
                    .tag("gamecontroller.fill")
                ChatView(session: session, repository: repository)
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
