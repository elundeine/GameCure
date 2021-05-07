//
//  UserProfileDetail.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 13.12.20.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import Combine

struct MyProfile: View {
    @State var session: SessionStore
    @State private var imageURL = URL(string: "")
    
    @State private var profileImage: Image?
    @State private var pickedImage: Image?
    @State private var imageData: Data = Data()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var newImage: Bool = false
    
    @State private var selectedTab: Int = 0
    
    @State var presentationMode = true
    @Binding var editProfile: Bool
    
    @State private var showingActionSheet = false
    @State private var showImage = false
    @State private var showSheet: Bool
    
    @State private var username: String
    let usernameLimit = 10
    
    @State var description: String
    let descriptionLimit = 75
    @State private var showDescription: Bool
    
    @State private var age: String
    @State private var showAge: Bool
    
    @State private var numberOfStones: String
    @State private var showNumberOfStones: Bool
    
    @State private var biggestStone: String
    let biggestStoneLimit = 20
    @State private var showBiggestStone: Bool
    
    @State private var mood:String
    @State private var showMood:Bool
    @State private var showMoodPicker:Bool
    
    @State private var title: String
    @State private var showTitle: Bool
    @State private var showTitlePicker: Bool
    
    @State private var showFinishedChallenges: Bool
    @State private var showCurrentChallenges: Bool
    @State private var showActiveSince: Bool
    
    init(editProfile: Binding<Bool>, session: SessionStore ){
        _session = State(initialValue: session)
        _username = State(initialValue: session.session!.username)
        _showSheet = State(initialValue: false)
        _showMoodPicker = State(initialValue: false)
        _showTitlePicker = State(initialValue: false)
        if(session.session!.description == nil){
            _showDescription = State(initialValue: false)
            _description = State(initialValue: "")
            _showAge = State(initialValue: false)
            _age = State(initialValue: "")
            _showNumberOfStones = State(initialValue: false)
            _numberOfStones = State(initialValue: "")
            _showBiggestStone = State(initialValue: false)
            _biggestStone = State(initialValue: "")
            _showMood = State(initialValue: false)
            _mood = State(initialValue: "Doing Fine")
            _showTitle = State(initialValue: false)
            _title = State(initialValue: "Stone Cutter")
        } else {
            _showDescription = State(initialValue: session.session!.description!.showDescription)
            if(session.session!.description!.showDescription){
                _description = State(initialValue: session.session!.description!.description!)
            } else {
                _description = State(initialValue: "")
            }
            
            _showAge = State(initialValue: session.session!.description!.showAge)
            if(session.session!.description!.showAge){
                _age = State(initialValue: session.session!.description!.age!)
            } else {
                _age = State(initialValue: "")
            }
            
            _showNumberOfStones = State(initialValue: session.session!.description!.showNumberOfStones)
            if(session.session!.description!.showNumberOfStones){
                _numberOfStones = State(initialValue: session.session!.description!.numberOfStones!)
            } else {
                _numberOfStones = State(initialValue: "")
            }
            
            _showBiggestStone = State(initialValue: session.session!.description!.showBiggestStone)
            if(session.session!.description!.showBiggestStone){
                _biggestStone = State(initialValue: session.session!.description!.biggestStone!)
            } else {
                _biggestStone = State(initialValue: "")
            }
            
            _showMood = State(initialValue: session.session!.description!.showMood)
            if(session.session!.description!.showMood){
                _mood = State(initialValue: session.session!.description!.mood!)
            } else {
                _mood = State(initialValue: "Doing Fine")
            }
            
            _showTitle = State(initialValue: session.session!.description!.showTitle)
            if(session.session!.description!.showTitle){
                _title = State(initialValue: session.session!.description!.title!)
            } else {
                _title = State(initialValue: "Stone Cutter")
            }
            
        }
        
        if(session.session!.stats == nil){
            _showFinishedChallenges = State(initialValue: false)
            _showCurrentChallenges = State(initialValue: false)
            _showActiveSince = State(initialValue: false)
        } else {
            _showFinishedChallenges = State(initialValue: session.session!.stats!.challengesFinished)
            _showCurrentChallenges = State(initialValue: session.session!.stats!.currentChallenges)
            _showActiveSince = State(initialValue: session.session!.stats!.activeSince)
        }
            self._editProfile = editProfile
    }
    
    func performOnAppear() {
        listen()
    }
    
    func listen() {
        session.listen()
    }
    
    func logOut() {
        session.logout()
    }
    
    func DismissSheet(){
        if(showMoodPicker){
            showMoodPicker = false
        } else if (showTitlePicker) {
            showTitlePicker = false
        } else {
            loadImage()
            showImage = false
        }
    }
    
    func loadImage() {
        guard let inputImage = pickedImage else { return }
        profileImage = inputImage
        newImage = true
    }
    
    func saveChanges(){
        session.addDescriptionStats(description: DescriptionModel(description: description, showDescription: showDescription, age: age, showAge: showAge, numberOfStones: numberOfStones, showNumberOfStones: showNumberOfStones, biggestStone: biggestStone, showBiggestStone: showBiggestStone, mood: mood, showMood: showMood, title: title, showTitle: showTitle),stats: StatsModel(challengesFinished: showFinishedChallenges, currentChallenges: showCurrentChallenges, activeSince: showActiveSince))
        StorageService.updateProfileImage(userId: session.session!.uid!, imageData: imageData, metaData: StorageMetadata(), storageProfileImageRef: StorageService.storageProfileId(userId: session.session!.uid!), onSuccess: {_ in }, onError: {_ in })
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if(editProfile) {
                        VStack {
                        HStack {
                            VStack {
                                if(newImage){
                                    HStack{
                                        profileImage!
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .onTapGesture {
                                                self.showingActionSheet = true
                                            }
                                    }.clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 5))

                                } else {
                                    HStack{
                                            WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .onTapGesture {
                                                self.showingActionSheet = true
                                            }

                                    }.clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 5))
                                }
                            }.padding(20)
                            VStack{
                                Text("Level 100")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                                HStack(){
                                    Text("Followers")
                                        .fontWeight(.semibold)
                                    Text("\(session.session!.followers?.count ?? 0)")
                                        .fontWeight(.semibold)
                                }
                                HStack(){
                                    Text("Experience")
                                        .fontWeight(.semibold)
                                    Text("\(session.session!.experience)")
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        ScrollView {
                            VStack {
                            Text("General")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                                VStack {
                                    HStack {
                                        Text("Username")
                                        Spacer()
                                        Spacer()
                                    }.padding(.all, 20)
                                    TextField("", text: $username)
                                        .onReceive(Just(username)) { newValue in
                                            if(newValue.count > usernameLimit) {
                                            username = String(username.prefix(usernameLimit))
                                        }
                                    }
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .border(Color.white, width: 1.0)
                                    .padding(.bottom, 20)
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                                    .foregroundColor(Color.black)
                                } .frame(maxWidth: .infinity, alignment: .center)
                                .background(Color(red: 32/255, green: 36/255, blue: 38/255))
                                .modifier(CardModifier())
                                .padding(.all, 10)
                                .foregroundColor(Color.white)
                            }
                            VStack {
                            Text("Description")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
//
                                optionalTextCard(name: "Description", showText: $showDescription, text: $description, textLimit: descriptionLimit)
                                optionalNumberCard(name: "Age", showNumber: $showAge, number: $age)
                                optionalNumberCard(name: "Number of Stones", showNumber: $showNumberOfStones, number: $numberOfStones)
                                optionalTextCard(name: "Biggest Stone", showText: $showBiggestStone, text: $biggestStone, textLimit: biggestStoneLimit)
                                optionalPickerCard(name: "Mood", showButton: $showMood, sheetCase: $showMoodPicker, showSheet: $showSheet, value: $mood)
                                optionalPickerCard(name: "Title", showButton: $showTitle, sheetCase: $showTitlePicker, showSheet: $showSheet, value: $title)
                            }
                            VStack {
                                Text("Stats")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                HStack{
                                    Text("Challenges finished")
                                        .padding(.leading, 10)
                                    Spacer()
                                    Toggle(isOn: $showFinishedChallenges) {
                                    }
                                    .padding(.trailing, 10)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                }.frame(maxWidth: .infinity, alignment: .center)
                                .background(Color(red: 32/255, green: 36/255, blue: 38/255))
                                .modifier(CardModifier())
                                .padding(.all, 10)
                                .foregroundColor(Color.white)
                                HStack{
                                    Text("Current Challenges")
                                        .padding(.leading, 10)
                                    Spacer()
                                    Toggle(isOn: $showCurrentChallenges) {
                                    }
                                    .padding(.trailing, 10)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                }.frame(maxWidth: .infinity, alignment: .center)
                                .background(Color(red: 32/255, green: 36/255, blue: 38/255))
                                .modifier(CardModifier())
                                .padding(.all, 10)
                                .foregroundColor(Color.white)
                                HStack{
                                    Text("Active Since")
                                        .padding(.leading, 10)
                                    Spacer()
                                    Toggle(isOn: $showActiveSince) {
                                    }
                                    .padding(.trailing, 10)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                }.frame(maxWidth: .infinity, alignment: .center)
                                .background(Color(red: 32/255, green: 36/255, blue: 38/255))
                                .modifier(CardModifier())
                                .padding(.all, 10)
                                .foregroundColor(Color.white)
                            }
                            Button(action: {
                                saveChanges()
                            }) {
                                Text("Save Changes")
                                    .font(Font.title2.bold().lowercaseSmallCaps())
                                    .multilineTextAlignment(.center)
                            }.foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                        }
                        }
                        .sheet(isPresented: $showSheet, onDismiss: DismissSheet) {
                            if(showMoodPicker){
                                ScrollView {
                                    Button(action: {
                                        mood = "Doing Fine"
                                    }) {
                                        Text("Doing Fine")
                                            .font(Font.title2.bold().lowercaseSmallCaps())
                                            .multilineTextAlignment(.center)
                                    }.foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    Button(action: {
                                        mood = "Okay"
                                    }) {
                                        Text("Okay")
                                            .font(Font.title2.bold().lowercaseSmallCaps())
                                            .multilineTextAlignment(.center)
                                    }.foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    Button(action: {
                                        mood = "Could be better"
                                    }) {
                                        Text("Could be better")
                                            .font(Font.title2.bold().lowercaseSmallCaps())
                                            .multilineTextAlignment(.center)
                                    }.foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    Button(action: {
                                        mood = "IN PAIN!!!"
                                    }) {
                                        Text("IN PAIN!!!")
                                            .font(Font.title2.bold().lowercaseSmallCaps())
                                            .multilineTextAlignment(.center)
                                    }.foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)

                                }.padding(30)
                            } else if (showTitlePicker) {
                                ScrollView {
                                    
                                    Button(action: {
                                        mood = "Stone Cutter"
                                    }) {
                                        Text("Stone Cutter")
                                            .font(Font.title2.bold().lowercaseSmallCaps())
                                            .multilineTextAlignment(.center)
                                    }.foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    
                                    Button(action: {
                                        mood = "Water Connoiseur"
                                    }) {
                                        Text("Water Connoiseur")
                                            .font(Font.title2.bold().lowercaseSmallCaps())
                                            .multilineTextAlignment(.center)
                                    }.foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    
                                    Button(action: {
                                        mood = "Shake Shake Shake it"
                                    }) {
                                        Text("Shake Shake Shake it")
                                            .font(Font.title2.bold().lowercaseSmallCaps())
                                            .multilineTextAlignment(.center)
                                    }.foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    
                                    Button(action: {
                                        mood = "NO PAIN NO GAIN"
                                    }) {
                                        Text("NO PAIN NO GAIN")
                                            .font(Font.title2.bold().lowercaseSmallCaps())
                                            .multilineTextAlignment(.center)
                                    }.foregroundColor(.white)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    
                                }.padding(30)
                            } else if(showImage) {
                            ImagePicker(pickedImage: self.$pickedImage, showImagePicker: self.$showSheet, imageData: self.$imageData)
                            }
                        }
                        .actionSheet(isPresented: $showingActionSheet) {
                            ActionSheet(title: Text(""), buttons:[
                                .default(Text("Choose A Photo")){
                                    self.sourceType = .photoLibrary
                                    showImage = true
                                    self.showSheet = true
                                },
                                .default(Text("Take A Photo")){
                                    self.sourceType = .camera
                                    showImage = true
                                    self.showSheet = true
                                }, .cancel()
                            ] )
                        }
                } else {
                    
                HStack {
                    VStack {
                        HStack{
                                WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                                .resizable()
                                    .frame(width: 100, height: 100)
                        }.clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 5))
                        
                        HStack{
                            Text(username)
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                        }
                    }.padding(20)
                    VStack{
                        Text("Level 100")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                        HStack(){
                            Text("Followers")
                                .fontWeight(.semibold)
                            Text("\(session.session!.followers?.count ?? 0)")
                                .fontWeight(.semibold)
                        }
                        HStack(){
                            Text("Experience")
                                .fontWeight(.semibold)
                            Text("\(session.session!.experience)")
                                .fontWeight(.semibold)
                        }
                    }
                }
            VStack {
                Picker(selection: $selectedTab,label: Text("")) {
                            Text("Description").tag(0)
                            Text("Stats").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                        switch(selectedTab) {
                        case 0: Description(description: description, showDescription: showDescription, age: age, showAge: showAge, numberOfStones: numberOfStones, showNumberOfStones: showNumberOfStones, biggestStone: biggestStone, showBiggestStone: showBiggestStone, mood: mood, showMood: showMood, title: title, showTitle: showTitle)
                        case 1: Stats(challengesFinished: showFinishedChallenges, currentChallenges: showCurrentChallenges, activeSince: showActiveSince)
                        default: Description(description: description, showDescription: showDescription, age: age, showAge: showAge, numberOfStones: numberOfStones, showNumberOfStones: showNumberOfStones, biggestStone: biggestStone, showBiggestStone: showBiggestStone, mood: mood, showMood: showMood, title: title, showTitle: showTitle)
                        }
                    }
                }
            }
        .onAppear(perform: performOnAppear)
    }
    }
}

