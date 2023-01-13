//
//  SignInView.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 04.01.2023.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @Environment(\.dismiss) var goBack
    
    @ObservedObject var showHome = AuthorizationModel()
    
    @State private var signInLog  = ""
    @State private var signInPass = ""
    @State private var sheet = false
    @State private var alert = false
    @State private var alertMessage = ""

    var body: some View {
        
        VStack {
            
            VStack {
                Text("Sign In")
                    .font(.system(size: 29) .bold())
                    .foregroundColor(.mint)
            }
            
            VStack {
                HStack {
                    Text("Username")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                TextField("Enter You're Username", text: $signInLog)
                    .textFieldStyle(CustomTextField(icon: "person", colorLeft: .blue, colorRight: .mint))
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
                SecureField("Enter You're password", text: $signInPass)
                    .textFieldStyle(CustomTextField(icon: "key", colorLeft: .blue, colorRight: .mint))
            }
            .padding()
            
            Button {
                AuthService.shared.SignIn(email: self.signInLog, password: self.signInPass) { result in
                    
                    switch result {
                        
                    case .success(_):
                        self.showHome.showHome.toggle()
                        
                    case .failure(let error):
                        self.alertMessage = "Error \(error.localizedDescription)"
                        self.alert.toggle()
                        
                        self.signInLog  = ""
                        self.signInPass = ""
                    }
                }
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
                SignUpView(showHome: self.showHome)
            }
            .alert(isPresented: $alert) {
                Alert(title: Text("\(alertMessage) 🦉"),
                      dismissButton: .default(Text("Ok")) )
            }
            .fullScreenCover(isPresented: $showHome.showHome) {
                HomeView(db: UserDBViewModel(UserDB: UserDB(id: "",
                                                            name: "",
                                                            phone: 0,
                                                            address: "")))
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
