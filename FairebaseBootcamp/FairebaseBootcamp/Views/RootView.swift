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
            AuthenticationEmailView()
        }
    }
}

//                    🔱
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
