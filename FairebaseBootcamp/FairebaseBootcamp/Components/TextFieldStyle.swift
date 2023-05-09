//
//  TextFieldStyle.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 09/05/2023.
//

import SwiftUI

struct CustomTextField: TextFieldStyle {
    
    let icon: String
    let colorLeft : Color
    let colorRight: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke( LinearGradient(colors: [colorLeft, colorRight],
                                        startPoint: .bottomLeading, endPoint: .topTrailing))
                .frame(width: 350, height: 50)
            HStack{
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                
                configuration
            }
            .padding(.leading, 29)
        }
    }
}

