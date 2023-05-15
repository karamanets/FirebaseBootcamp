//
//  RootView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 10/05/2023.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            VStack (spacing: 20){
                
                NavigationLink {
                    AuthenticationEmailView()
                } label: {
                    Text("Authentication with Email")
                        .modifier(ButtonLink(color: .pink))
                }
                
                NavigationLink {
                    GoogleSignIn()
                } label: {
                    Text("Authentication with Google")
                        .modifier(ButtonLink(color: .purple))
                }
                
                NavigationLink {
                    SignInView_Apple()
                } label: {
                    Text("Authentication with Apple")
                        .modifier(ButtonLink(color: .black))
                }
            }
        }
    }
}

//                    🔱
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}


