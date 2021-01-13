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
    @EnvironmentObject var session: SessionStore
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
    @State private var showSheet = false
    
    @State private var username =  ""
    let usernameLimit = 10
    
    @State private var description = ""
    let descriptionLimit = 75
    @State private var showDescription = true
    
    @State private var age = ""
    @State private var showAge = true
    
    @State private var numberOfStones = ""
    @State private var showNumberOfStones = true
    
    @State private var biggestStone = ""
    let biggestStoneLimit = 20
    @State private var showBiggestStone = true
    
    @State private var mood = "Doing Fine"
    @State private var showMood = true
    @State private var showMoodPicker = false
    
    @State private var title = "Stone Cutter"
    @State private var showTitle = true
    @State private var showTitlePicker = false
    
    @State private var showFinishedChallenges = true
    @State private var showCurrentChallenges = true
    @State private var showActiveSince = true
    
    func performOnAppear() {
        listen()
        loadData()
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
    
    func loadData(){
        username = session.session!.username
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
                                Text("Username")
                            TextField("", text: $username)
                                .fixedSize()
                                .onReceive(Just(username)) { newValue in
                                    if(newValue.count > usernameLimit) {
                                        username = String(username.prefix(usernameLimit))
                                    }
                                }
                                .padding()
                                .border(Color.white, width: 1.0)
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
                                    Spacer()
                                    Toggle(isOn: $showFinishedChallenges) {
                                    }
                                }
                                HStack{
                                    Text("Current Challenges")
                                    Spacer()
                                    Toggle(isOn: $showCurrentChallenges) {
                                    }
                                }
                                HStack{
                                    Text("Active Since")
                                    Spacer()
                                    Toggle(isOn: $showActiveSince) {
                                    }
                                }

                            }
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
                                    Button("Stone Cutter"){
                                        mood = "Stone Cutter"
                                    }
                                    Button("Water Connoiseur"){
                                        mood = "Water Connoiseur"
                                    }
                                    Button("Shake Shake Shake it"){
                                        mood = "Shake Shake Shake it"
                                    }
                                    Button("No Pain no Gain"){
                                        mood = "No Pain no Gain"
                                    }

                                }
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
                            Text(session.session!.username)
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
                            case 0: Description()
                            case 1: Stats()
                            default: Description()

                        }
                    }
                }
            }
    
        .onAppear(perform: performOnAppear)
    }
    }
}

