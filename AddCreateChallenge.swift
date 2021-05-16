//
//  AddCreateChallenge.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct AddCreateChallenge: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var repository: Repository
    @StateObject var categoryListVM : CategoryListViewModel
    
    @State private var title = ""
    @State private var durationDays = 7
    @State private var interval = ""
    @State private var searchName = [""]
    @State private var description = ""
    @State private var completed = false
    @State private var challengeCreater = ["" : ""]
    @State private var showingAlert = false
    @State private var showChallengeCompletedAlert = false
    @State private var alertTitle: String  = "Oh no 😭"
    @State private var error: String = ""
//    @State private var challengeCardColor
    
    @State var showCreatedAlert = false
    @State var id: Challenge.ID? = nil
    
    @State private var intervalOptions = ["Daily","Weekly","Monthly"]
    @State private var selectedInterval = 0
    @State private var selectedCategory = "Other"
    @State private var selectedDuration = 0
    var durationOptions = ["1 Week","2 Weeks","3 Weeks", "4 Weeks"]
   // static func newChallenge(title: String, durationDays: String, interval: String, searchName: [String], description: String, completed: Bool, challengeCreater: String)
    
    init(session: SessionStore, repository: Repository) {
        self.session = session
        self.repository = repository
        _categoryListVM = StateObject(wrappedValue: CategoryListViewModel(repository: repository))
    }
    func listen() {
        session.listen()
    }
    
    func save() {
        if selectedDuration == 1 {
            self.durationDays = 14
        } else if selectedDuration == 2 {
            self.durationDays = 21
        } else if selectedDuration == 3 {
            self.durationDays = 28
        }
        DispatchQueue.main.async {
            
            self.repository.addChallenge(Challenge(title: self.title, category: self.selectedCategory, durationDays: self.durationDays, interval: "1", searchName: self.title.splitStringtoArray(), description: self.description, completed: self.completed, challengeCreater: session.session?.username ?? "", userIds: [session.session?.uid ?? ""]))
            
        }
    }
    
    func errorCheck() -> String? {
        if title.trimmingCharacters(in: .whitespaces).isEmpty || description.trimmingCharacters(in: .whitespaces).isEmpty  {
            return "Please add fill out all necessary information"
        }
        
        return nil
    }
    
    func clear() {
        self.title = ""
        self.selectedDuration = 0
        self.description = ""
        
    }
    
    func uploadPost() {
        let group = DispatchGroup()
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            return
        }
        group.enter()
        self.save()
        group.leave()
        print("saved now clear challenge")
        group.notify(queue: DispatchQueue.global()) {
            self.showChallengeCompletedAlert = true
            return
        }
        
    }
        
    var body: some View {
        NavigationView {
        VStack{
        Text("Add a new daily Challenge").font(.title)
        Form {
            Section (header: Text("Title")) {
                TextField("", text: $title)
                    .textFieldStyle(MyTextFieldStyle())
                
            }
            Section (header: Text("Do")) {
                TextField("", text: $description)
                    .textFieldStyle(MyTextFieldStyle())
            }
            Section (header: Text("For")) {
                VStack{
                Picker(selection: $selectedDuration, label: Text("Choose a Challenge Duration")) {
                            ForEach(0 ..< durationOptions.count) {
                               Text(self.durationOptions[$0])
                            }
                        }
                }.frame(maxWidth: .infinity)
                .clipped()
            }
            Section (header: Text("Category")) {
                Picker(selection: $selectedCategory, label: Text("Color")) {
                    ForEach(categoryListVM.categoryCellViewModels) { categoryCellVM in
                        Text(categoryCellVM.name).tag(categoryCellVM.name)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.blue, lineWidth: 3)
                )
            }
            Button(action:  {self.uploadPost()}) {
                Text("save")
                    .foregroundColor(Color.white)
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("Ok")))
            }
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
            .background(Color.blue)
            .cornerRadius(5)
                
        }.listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("Ok")))
        }
        .alert(isPresented: $showChallengeCompletedAlert) {
            Alert(title: Text("Challenge was created successfully!"), message: Text("The challenge is now displayed in your dashboard."), dismissButton: .default(Text("Ok")))
        }
        .onAppear(perform: listen)    }
    }
    }
}
struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.blue, lineWidth: 3)
        )
            .keyboardType(.default)
            
    }
}
//
//struct AddCreateChallenge_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCreateChallenge()
//    }
//}


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
