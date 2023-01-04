//
//  SignInView.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 04.01.2023.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @State private var signInLog  = ""
    @State private var signInPass = ""
    
    @State private var sheet = false
    
    var body: some View {
        
        VStack {
            Text("Sign In")
                .font(.system(size: 29) .bold())
                .foregroundColor(.mint)
            
            VStack {
                HStack {
                    Text("Username")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                TextField("Enter Youre Username", text: $signInLog)
                    .textFieldStyle(CustomTextField(icon: "person", colorleft: .blue, colorRight: .mint))
            }
            .padding(.horizontal)
            
            VStack {
                HStack {
                    Text("Password")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                SecureField("Enter Youre password", text: $signInPass)
                    .textFieldStyle(CustomTextField(icon: "key", colorleft: .blue, colorRight: .mint))
            }
            .padding()
            
            Button {
                //
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.mint)
                        .frame(width: 260, height: 60)
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.system(size: 19))
                }
            }
            .padding(.top, 35)
            
            Text("OR")
                .font(.system(size: 19))
                .foregroundColor(.secondary)
                .padding(.top)
            
            HStack {
                
                Text("Don't Have An Account?")
                    .font(.system(size: 19))
                    .foregroundColor(.secondary)
                
                Text("Sign Up")
                    .foregroundColor(.blue)
                    .font(.system(size: 19) .bold())
                    .onTapGesture {
                        self.sheet = true
                    }
            }
            .padding()
            
            .sheet(isPresented: $sheet) {
                SingUpView()
            }
        }
    }
//    func login() {
//        Auth.auth().signIn(withEmail: <#T##String#>, password: <#T##String#>)
//    }
    
    func registr() {
        Auth.auth().createUser(withEmail: signInLog, password: signInPass) { resalt, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
}
//                   🔱
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
