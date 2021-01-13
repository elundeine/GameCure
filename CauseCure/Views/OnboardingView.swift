//
//  OnboardingView.swift
//  CauseCure
//
//  Created by user188094 on 1/7/21.
//

import SwiftUI

struct OnboardingView: View {
    
    @State public var selectedTab: Int = 0
    
    var body: some View {
        
        switch(selectedTab) {
            case 0:
                VStack {
                    firstOnboarding()
                    Button(action: {
                        selectedTab += 1
                    }) {
                        Text("Start your Jorney")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                }
            case 1:
                VStack {
                    homeViewOnboarding()
                    Button(action: {
                        selectedTab += 1
                    }) {
                        Text("Open Profile")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                }
            case 2:
                VStack {
                    profileViewOnboarding()
                    Button(action: {
                        selectedTab += 1
                    }) {
                        Text("Find Challenges")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                }
            case 3:
                VStack {
                    challengesViewOnboarding()
                    Button(action: {
                        selectedTab += 1
                    }) {
                        Text("Create your own Challenge")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                }
            case 4:
                VStack {
                    createChallengeViewOnboarding()
                    Button(action: {
                        selectedTab += 1
                    }) {
                        Text("Finish Tutorial")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                        
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                }
            default: lastOnboarding()
        }
        
        
    }
    
}

struct firstOnboarding: View {
    
    var body: some View {
        Spacer()
        Text("Welcome To CauseCure")
            .font(Font.title.bold().lowercaseSmallCaps())
            .multilineTextAlignment(.center)
        Text("We can fight the stone together!")
        Spacer()
        Text("Are you ready for your journey?!")
        Spacer()
        
    }
}

struct homeViewOnboarding: View {
    
    var body: some View {
        Spacer()
        Text("Home Screen")
            .font(Font.title.bold().lowercaseSmallCaps())
            .multilineTextAlignment(.center)
        Spacer()
        Image("HomeView")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 500, alignment: .center)
        Spacer()
        Text("Here you can go to your Profile or view your Challenges")
            .multilineTextAlignment(.center)
        Spacer()
    }
        
}

struct profileViewOnboarding: View {
    
    var body: some View {
        Spacer()
        Text("Profile")
            .font(Font.title.bold().lowercaseSmallCaps())
            .multilineTextAlignment(.center)
        Spacer()
        Image("ProfileView")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 500, alignment: .center)
        Spacer()
        Text("See all your achivements and display yourself!")
            .multilineTextAlignment(.center)
        Spacer()
    }
        
}

struct challengesViewOnboarding: View {
    
    var body: some View {
        Spacer()
        Text("Find Challenges")
            .font(Font.title.bold().lowercaseSmallCaps())
            .multilineTextAlignment(.center)
        Spacer()
        Image("ChallengeView")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 500, alignment: .center)
        Spacer()
        Text("Browse or Search all Challenges from your fellow Kidney Fighters!")
            .multilineTextAlignment(.center)
        Spacer()
    }
        
}

struct createChallengeViewOnboarding: View {
    
    var body: some View {
        Spacer()
        Text("Create Challenges")
            .font(Font.title.bold().lowercaseSmallCaps())
            .multilineTextAlignment(.center)
        Spacer()
        Image("CreateChallenge")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 500, alignment: .center)
        Spacer()
        Text("Create your own Challenges and share with your Friends!")
            .multilineTextAlignment(.center)
        Spacer()
    }
        
}

struct lastOnboarding: View {
    var body: some View {
        Spacer()
        Image("trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80, alignment: .center)
        Spacer()
        Text("You have made it through the tutorial!")
            .font(Font.title.bold().lowercaseSmallCaps())
            .multilineTextAlignment(.center)
        Spacer()
        Text("Swipe down to Start!")
            .font(Font.title.bold().lowercaseSmallCaps())
            .multilineTextAlignment(.center)
        Spacer()
    }
}
