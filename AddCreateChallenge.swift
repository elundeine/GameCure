//
//  AddCreateChallenge.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct AddCreateChallenge: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var challengeListVM = ChallengeListViewModel()
    @ObservedObject var categoryListVM = CategoryListViewModel()
    
    @State private var title = ""
    @State private var durationDays = ""
    @State private var interval = ""
    @State private var searchName = [""]
    @State private var description = ""
    @State private var completed = false
    @State private var challengeCreater = ["" : ""]
    
    @State var id: Challenge.ID? = nil
    
    @State private var intervalOptions = ["Daily","Weekly","Monthly"]
    @State private var selectedInterval = 0
    @State private var selectedCategory = "Other"
    
   // static func newChallenge(title: String, durationDays: String, interval: String, searchName: [String], description: String, completed: Bool, challengeCreater: String)
    func listen() {
        session.listen()
    }
    
    func save() {
        if selectedInterval == 0 {
            self.challengeListVM.addChallenge(challenge: Challenge(title: self.title, category: self.selectedCategory, durationDays: self.durationDays, interval: "1", searchName: self.title.splitStringtoArray(), description: self.description, completed: self.completed, challengeCreater: session.session?.username ?? "", userIds: [session.session?.uid ?? ""]))
        } else if selectedInterval == 1 {
            self.challengeListVM.addChallenge(challenge: Challenge(id:id as! String, title: self.title, category: self.selectedCategory, durationDays: self.durationDays, interval: "7", searchName: self.title.splitStringtoArray(), description: self.description, completed: self.completed, challengeCreater: "", userIds: [""]))
        } else {
            self.challengeListVM.addChallenge(challenge: Challenge(id:id as! String, title: self.title, category: self.selectedCategory, durationDays: self.durationDays, interval: "30", searchName: self.title.splitStringtoArray(), description: self.description, completed: self.completed, challengeCreater: "", userIds: [""]))
        }
    }
    
    
    var body: some View {
        VStack{
        Text("Add a new Challenge").font(.title)
        Form {
            Section (header: Text("Title")) {
                TextField("Fill in the challenge titel", text: $title)
            }
            Section (header: Text("Description")) {
                TextField("Please add a exhausive description of the challenge", text: $description)
            }
            Section (header: Text("Duration")) {
                TextField("For how many days should the challenge last", text: $durationDays)
            }
//            Section (header: Text("Interval")) {
//                Picker(selection: $selectedInterval, label: Text("Color")) {
//                                   ForEach(0..<3, id: \.self) { index in
//                                       Text(self.intervalOptions[index]).tag(index)
//                                   }
//                               }.pickerStyle(SegmentedPickerStyle())
//            }
            Section (header: Text("Category")) {
                Picker(selection: $selectedCategory, label: Text("Color")) {
                    ForEach(categoryListVM.categoryCellViewModels) { categoryCellVM in
                        Text(categoryCellVM.name).tag(categoryCellVM.name)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Button(action:  {self.save()}) {
                Text("save")
            }
                
        }.listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .onAppear(perform: listen)    }
    }
}

struct AddCreateChallenge_Previews: PreviewProvider {
    static var previews: some View {
        AddCreateChallenge()
    }
}


//if presentAddNewItem {
//    ChallengeCell(challengeCellVM: ChallengeCellViewModel.newChallenge()) { result in
//        if case .success(let challenge) = result {
//            print("success")
//          self.challengeListVM.addChallenge(challenge: challenge)
//        }
//        self.presentAddNewItem.toggle()
//      }
//
//}
//}.listStyle(PlainListStyle())
