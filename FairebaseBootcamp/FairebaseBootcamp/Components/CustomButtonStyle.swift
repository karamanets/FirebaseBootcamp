//
//  CustomButtonStyle.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 10/05/2023.
//

import SwiftUI

//MARK: ButtonModifier
struct ButtonStyles: ButtonStyle {
    
    let scale  : CGFloat
    let opacity: CGFloat
    
    init(scale: CGFloat, opacity: CGFloat) {
        self.scale = scale
        self.opacity = opacity
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.mint)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)
            .shadow(color: .mint.opacity(0.5), radius: 10, x: 0, y: 10)
        //====== configuration - после
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? opacity : 1.0)
            .brightness(configuration.isPressed ? 0.3 : 0.0)
    }
}

//MARK: Extension for ButtonModifier
extension View {
    
    func buttonMode(scale: CGFloat = 0.9, opacity: CGFloat = 0.9) -> some View {
        buttonStyle(ButtonStyles(scale: scale, opacity: opacity))
    }
}

//MARK: RootView button link style
struct ButtonLink: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 25) .bold())
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal)
            .shadow(color: color, radius: 10)
    }
}
