//
//  SignInView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var session: SessionStore
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var error: String = ""
    @State private var showingAlert = false
    @State private var alertTitle: String  = "Oh no 😭"

    func errorCheck() -> String? {
        if email.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters(in: .whitespaces).isEmpty {
            
            return "Please fill in a valid email and password"
            
        }

        return nil
    }
    
    
    func clear() {
        self.email = ""

        self.password = ""
    }
    
    func signIn() {
        if let error = errorCheck() {
            print("here")
            self.error = error
            self.showingAlert = true
            self.clear()
            return
        }
        AuthService.signIn(email: email, password: password, onSuccess: {
            (user) in
            self.clear()
            
        }) {
            (errorMessage) in
            print("Error \(errorMessage)")
            self.error = errorMessage
            self.showingAlert = true
            return
        }
        
    }
    
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack {
                    Image("kidney")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .padding(.all, 20)
                    Text("CauseCure")
                    
                    //TODO:Place Logo
                    // Image(systemName: "")
                }
                VStack {
                    Text("welcome back!").font(.system(size: 32, weight: .heavy))
                        .foregroundColor(.blue)
                    Text("Sign in to contine").font(.system(size: 16, weight: .medium))
                    
                
                }
                    FormField(value: $email, icon: "mail", placeholder: "E-mail")
                    FormField(value: $password, icon: "lock", placeholder: password, isSecure: true)
                    
                Button(action: signIn) {
                        Text("Sign In").font(.title).modifier(ButtonModifier())
                        
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("Ok")))
                    }
                HStack{
                    Text("New?").font(.system(size: 20))
                    NavigationLink(destination: SignUpView(session: self.session)) {
                        Text("Create an Account").font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }
                
            }.padding()
        }
    }
}

//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
