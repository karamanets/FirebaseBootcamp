//
//  HomeView.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 04.01.2023.
//

import SwiftUI

struct HomeView: View {
    
    let someRandomImage = URL(string: "https://picsum.photos/400")
    
    var body: some View {
        
        NavigationStack {
            VStack {
                AsyncImage(url: someRandomImage) { image in
                    switch image {
                        
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 300, height: 300)
                            .shadow(color: .black.opacity(0.6), radius: 4, x: 4, y: 4)
                    case .failure:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                } .navigationTitle("Hello")
            }
        }
    }
}
//                      🔱
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
