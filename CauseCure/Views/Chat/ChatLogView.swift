//
//  ChatLogView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 05.01.21.
//

import SwiftUI

struct ChatLogView: View {
//    @ObservedObject var messageListVM : MessageListViewModel
    @ObservedObject var session : SessionStore
    @State var write = ""
    @State private var messageImage: Image?
    @State private var pickedImage: Image?
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var imageData: Data = Data()

    @State private var sourceType : UIImagePickerController.SourceType = .photoLibrary

    @ObservedObject private var keyboard = KeyboardInfo.shared
    
    func loadImage() {
//        guard let inputImage = pickedImage else { return }
//        postImage = inputImage
    }
    
    
    func clear() {
//        self.text = ""
//        self.imageData = Data()
//        self.postImage = Image(systemName: "photo.fill")
        
    }
    
    var body: some View {
        VStack {
//            List(messages, id:\.self) { message in
//                ChatRow(message: message, uid: self.session.uid)
//            }
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .center){
//                    ForEach(messageListVM.messageCellViewModels) { message in
//                        ChatRow(message: message.l, uid: session.session?.uid ?? "")
//                        Text(message.message.textMessage)
//                        .padding(.vertical,6)
//                    }
                }.frame(width: 374)
            }

            HStack {
                cameraButtton
                TextField("message...",text: self.$write).padding(10)
                    .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                .cornerRadius(25)

                Button(action: {
                    if self.write.count > 0 {
//                        self.session.sendData(user: self.user, message: self.write)
                        self.write = ""
                    } else {

                    }
                }) {
                    Image(systemName: "paperplane.fill").font(.system(size: 20))
                        .foregroundColor((self.write.count > 0) ? Color.blue : Color.gray)
                        .rotationEffect(.degrees(50))

                }
            }.padding()
             .padding(.bottom, self.keyboard.keyboardIsUp ? 300 :0)

            }
    }
    private var cameraButtton : Button<Image> {
        return Button(action: {
            self.showingActionSheet = true
        }){
            Image(systemName: "camera")
        }
    }
}

//struct ChatLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatLogView()
//    }
//}

