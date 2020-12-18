//
//  SignInView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 08.12.20.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var sharedInt:SharedInt

    
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
            self.error = error
            self.showingAlert = true
            return
        }
        AuthService.signIn(email: email, password: password, onSuccess: {
            (user) in
            self.clear()
            print("changing shared Int")
            self.sharedInt.myInt = 1
            
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
                    Text("CauseCure")
                    
                    //TODO:Place Logo
                    // Image(systemName: "")
                }
                VStack {
                    Text("welcome back!").font(.system(size: 32, weight: .heavy))
                    Text("Sign in to contine").font(.system(size: 16, weight: .medium))
                    
                
                }
                    FormField(value: $email, icon: "mail", placeholder: "E-mail")
                    FormField(value: $password, icon: "lock", placeholder: password, isSecure: true)
                    
                Button(action: {signIn()}) {
                        Text("Sign In").font(.title).modifier(ButtonModifier())
                        
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("Ok")))
                    }
                HStack{
                    Text("New?").font(.system(size: 20))
                    NavigationLink(destination: SignUpView()) {
                        Text("Create an Account").font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
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
