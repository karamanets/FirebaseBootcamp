//
//  SignInUp.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 10/05/2023.
//

import SwiftUI

struct SignInUp: View {
    
    @ObservedObject var vm: SignInEmail
    
    var body: some View {
        VStack {
            label
            VStack {
                HStack {
                    Text("Username")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                TextField("Enter You're Username", text: $vm.email)
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
                SecureField("Enter You're password", text: $vm.password)
                    .textFieldStyle(CustomTextField(icon: "key", colorLeft: .blue, colorRight: .mint))
            }
            .padding()
            
            Button {
                vm.signUp()
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
            signUpInfo
                .alert(isPresented: $vm.alert) {
                    Alert(title: Text("\(vm.alertMessage) 🦉"),
                          message: Text(""),
                          dismissButton: .default(Text("Ok")) {
                        guard vm.user != nil else { return }
                        withAnimation(.spring()) {
                            vm.isSignIn = true
                        }
                    })
                }
        }
    }
}

//               🔱
struct SignInUp_Previews: PreviewProvider {
    static var previews: some View {
        SignInUp(vm: SignInEmail())
    }
}

/// Sign In Label
private var label: some View {
    Text("Sign In")
        .font(.system(size: 29) .bold())
        .foregroundColor(.mint)
}

/// Sign Up info
private var signUpInfo: some View {
    VStack {
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
            
        }
        .padding()
    }
}
