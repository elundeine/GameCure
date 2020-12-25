//
//  CustomSearchBar.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 21.12.20.
//

import SwiftUI
import UIKit

struct CustomSearchBar: View {
    @ObservedObject var challengeRepository : ChallengeRepository
//    @Binding var challenges : [Challenge]
    @State var txt = ""
    @State private var showCancelButton: Bool = false
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "magnifyingglass")
                TextField("search", text: $txt, onEditingChanged: { isEditing in
                                            self.showCancelButton = true
                                        }, onCommit: {
                                            print("onCommit")
                                        }).foregroundColor(.primary)

                                        Button(action: {
                                            self.txt = ""
                                        }) {
                                            Image(systemName: "xmark.circle.fill").opacity(txt == "" ? 0 : 1)
                                        }
                                    }
                                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                    .foregroundColor(.secondary)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10.0)

                                    if showCancelButton  {
                                        Button("Cancel") {
                                                // this must be placed before the other commands here
                                                self.txt = ""
                                                self.showCancelButton = false
                                        }
                                        .foregroundColor(Color(.systemBlue))
                                    }
                                }
                                .padding(.horizontal)
                                .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly
        
        List(self.challengeRepository.challenges.filter { $0.title.lowercased().contains(self.txt.lowercased())}) { i in
            NavigationLink(destination: ChallengeCellDetail(challengeCellVM: ChallengeCellViewModel(challenge: i), myChallenge: challengeRepository.checkIfIDoThe(i) )) {
                            Text(i.title)
                        }
                    }.frame(height: UIScreen.main.bounds.height / 5)
                }
            
            }
    

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
//
//struct CustomSearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomSearchBar()
//    }
//}
