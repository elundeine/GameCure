//
//  Post.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 04.01.21.
//

import SwiftUI
import UIKit


struct Post: View {
    @Binding var presentationMode: PresentationMode
    @State private var postImage: Image?
    @State private var pickedImage: Image?
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var imageData: Data = Data()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var error: String = ""
    @State private var showingAlert = false
    @State private var alertTitle: String  = "Oh no 😭"
    @State private var text = ""
    
    func loadImage() {
        guard let inputImage = pickedImage else { return }
        postImage = inputImage
    }
    
    
    func clear() {
        self.text = ""
        self.imageData = Data()
        self.postImage = Image(systemName: "photo.fill")
        
    }
    
    func errorCheck() -> String? {
        if text.trimmingCharacters(in: .whitespaces).isEmpty || imageData.isEmpty {
            return "Please add a caption and provide an image"
        }
        
        return nil
    }
    
    func uploadPost() {
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            self.clear()
            return
        }
        PostService.uploadPost(caption: text, imageData: imageData, onSuccess: {
            self.clear()}) {
            (errorMessage) in
      
            self.error = errorMessage
            self.showingAlert = true
            return
        }
        presentationMode.dismiss()
    }
    
    
    var body: some View {
  
        VStack{
            if postImage != nil {
                postImage!.resizable()
                    .frame(width: 300, height: 200)
                    .onTapGesture {
                        self.showingActionSheet = true
                    }
            } else {
                Image(systemName: "photo").resizable().scaledToFit()
                    .frame(width: 300, height: 200)
                    .onTapGesture {
                        self.showingActionSheet = true
                    }
            }
            TextEditor(text: $text)
                .frame(height: 200)
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
                .padding(.horizontal)
                            Button(action: uploadPost) {
                Text("Upload Post").font(.title).modifier(ButtonModifier())
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("Ok")))
            }


        }.padding()
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(pickedImage: self.$pickedImage, showImagePicker: self.$showingImagePicker, imageData: self.$imageData)
        }.actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(""), buttons:[
                .default(Text("Choose A Photo")){
                    self.sourceType = .photoLibrary
                    self.showingImagePicker = true
                },
                .default(Text("Take A Photo")){
                    self.sourceType = .camera
                    self.showingImagePicker = true
                }, .cancel()
            ] )
        }.onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}
    

//struct Post_Previews: PreviewProvider {
//    static var previews: some View {
//        Post()
//    }
//}
extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
 }

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}
