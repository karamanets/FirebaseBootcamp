//
//  SignInUpView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 10/05/2023.
//

import SwiftUI

struct SignInUpView: View {
    
    @ObservedObject var vm: SignInEmailViewModel
    
    var body: some View {
        VStack {
            label
            
            emailAndEmailField
            
            Button {
                /// If email NOT exist in firebase -> signUp
                Task {
                    do {
                        try await vm.signUp()
                        return
                    } catch let error {
                        print("[⚠️] Error: \(error.localizedDescription)")
                    }
                }
                /// If email exist in firebase -> signIn
                Task {
                    do {
                        try await vm.signIn()
                        withAnimation(.spring()) {
                            guard vm.user != nil else { return }
                            vm.isSignIn = true
                        }
                    } catch let error {
                        print("[⚠️] Error: \(error.localizedDescription)")
                    }
                }
            } label: { buttonView }
                .padding(.top, 35)
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
        SignInUpView(vm: SignInEmailViewModel())
    }
}

//MARK: Component
extension SignInUpView {
    
    /// Sign In Label
    private var label: some View {
        Text("Sign In/Up")
            .font(.system(size: 29) .bold())
            .foregroundColor(.mint)
    }
    
    /// Email Field
    private var emailAndEmailField: some View {
        VStack {
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
        }
    }
    
    /// Button View
    private var buttonView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.mint)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
            Text("Sign In")
                .foregroundColor(.white)
                .font(.system(size: 19))
        }
    }
}


