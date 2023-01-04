//
//  SingUpView.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 04.01.2023.
//

import SwiftUI

struct SingUpView: View {
    
    @State private var signInLog  = ""
    @State private var signInPass = ""
    
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
                .offset(x: -160, y: -155)
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
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.system(size: 19))
                }
            }
            .padding(.top, 35)
        }
    }
}

//                    🔱
struct SingUpView_Previews: PreviewProvider {
    static var previews: some View {
        SingUpView()
    }
}
