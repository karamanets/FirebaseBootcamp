//
//  SingUpView.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 04.01.2023.
//

import SwiftUI

struct SingUpView: View {
    
    @ObservedObject var showHome = AuthorizationModel()
    
    @State private var signUpLog  = ""
    @State private var signUpPass = ""
    @State private var signUpPassConfirm = ""
    @State private var alert = false
    @State private var alertMessage = ""
    
    @Environment(\.dismiss) var goBack
    
    var body: some View {
        
        VStack {
            
            VStack {
                Button {
                    goBack()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 24) .bold())
                        .foregroundColor(.mint)
                }
                .offset(x: -160, y: -85)
            }
            Text("Sign Up")
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
                TextField("Enter Youre Username", text: $signUpLog)
                    .textFieldStyle(CustomTextField(icon: "person", colorleft: .blue, colorRight: .mint))
            }
            .padding(.top)
            
            VStack {
                HStack {
                    Text("Password")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                SecureField("Enter Youre password", text: $signUpPass)
                    .textFieldStyle(CustomTextField(icon: "key", colorleft: .blue, colorRight: .mint))
            }
            .padding(.top)
            
            VStack {
                HStack {
                    Text("Password")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                SecureField("Confirm password", text: $signUpPassConfirm)
                    .textFieldStyle(CustomTextField(icon: "key", colorleft: .blue, colorRight: .mint))
            }
            .padding(.top)
            
            Button {
                if signUpPass == signUpPassConfirm {
                    
                    AuthService.shared.SingUP(user: self.signUpLog,
                                              passwprd: self.signUpPass) { result in
                        switch result {
                        case .success(let user):
                            self.alertMessage = "Congratulations you have an Account! You're email is : \(user.email!)"
                            self.alert.toggle()
                            self.signUpLog = ""
                            self.signUpPass = ""
                            self.signUpPassConfirm = ""
                            
                            DispatchQueue.main.async {
                                self.showHome.showHome.toggle()
                            }
                            
                        case .failure(let error):
                            self.alertMessage = "Error \(error.localizedDescription)"
                            self.alert.toggle()
                            self.signUpPass = ""
                            self.signUpPassConfirm = ""
                        }
                    }
                } else {
                    self.alertMessage = "Error"
                    self.alert.toggle()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.mint)
                        .frame(width: 260, height: 60)
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.system(size: 19))
                }
            }
            .padding(.top, 85)
            
            .alert(isPresented: $alert) {
                Alert(title: Text("\(alertMessage) 📌"),
                      dismissButton: .default(Text("Ok")) { goBack() } )
            }
//            .fullScreenCover(isPresented: $showHome.showHome) {
//                
//                let user = UserViewModel(user: AuthService.shared.currentUser!)
//                
//                HomeView(vm: user)
//            }
            
        }
    }
}

//                    🔱
struct SingUpView_Previews: PreviewProvider {
    static var previews: some View {
        SingUpView()
    }
}
