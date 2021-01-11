//
//  MyChallengesView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 22.12.20.
//

import SwiftUI

struct MyChallengesView: View {
    @ObservedObject var userChallengeListVM : UserChallengeListViewModel
    @AppStorage("selectedTab") private var selectedTab = "house.fill"
    
    var body: some View {
        Text("")
        if(userChallengeListVM.userChallengeCellViewModels.isEmpty){
            HStack(){
                Spacer()
                VStack(){
                    Spacer()
                    Text("You have no Challenges!")
                        .font(Font.title.bold().lowercaseSmallCaps())
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                            selectedTab = "magnifyingglass"
                    }) {
                        Text("Browse Challenges")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                    Button(action: {
                            selectedTab = "plus.circle.fill"
                    }) {
                        Text("Create a Challenge")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                    Spacer()
                }
                Spacer()
            }
        } else {
            List {
                ForEach(userChallengeListVM.userChallengeCellViewModels) { userChallengeCellVM in
                    ZStack{
                    NavigationLink(destination: UserChallengeCellDetail(userChallengeCellVM: userChallengeCellVM)) {
                        EmptyView()
                    }.opacity(0.0)
                    .buttonStyle(PlainButtonStyle())
                       UserChallengeCard(userChallengeCellVM: userChallengeCellVM)
                   
                   }
                }
            }
        }
    }
}

struct UserChallengeCard: View {
    @ObservedObject var userChallengeCellVM: UserChallengeCellViewModel
    
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

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}

//struct MyChallengesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyChallengesView()
//    }
//}
