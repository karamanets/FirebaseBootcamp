//
//  SomeView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import SwiftUI

struct SomeView: View {
    
    var body: some View {
        
        ZStack {
            backgroundColor
            
            Text("Hello SwiftUi")
                .font(.system(size: 33) .bold())
        }
    }
}

//               🔱
struct SomeView_Previews: PreviewProvider {
    static var previews: some View {
        SomeView()
    }
}

/// Background Color
private var backgroundColor: some View {
    LinearGradient(colors: [.orange, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
}

