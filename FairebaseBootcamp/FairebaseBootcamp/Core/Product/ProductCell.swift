//
//  ProductCell.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 22/05/2023.
//

import SwiftUI

struct ProductCell: View {
    
    let product: Product
    
    var body: some View {
        HStack (alignment: .top, spacing: 10){
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 85, height: 85)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: .pink.opacity(0.5), radius: 4, x: 0, y: 3)
            
            VStack (alignment: .leading) {
                Text(product.title ?? "")
                    .foregroundColor(.primary)
                    .font(.title3 .bold())
                    
                
                Text("Price $" + String(product.price ?? 0))
                
                Text("Brand: " + String(product.brand ?? ""))
                
                Text("Category: " + String(product.category ?? ""))
                
                Text("Rating: " + String(product.rating ?? 0))
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
    }
}

//                🔱
struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: Product(id: 1,
                                     title: "Apple",
                                     description: "hello",
                                     price: 1200,
                                     discountPercentage: 0,
                                     rating: 4.99,
                                     stock: 120,
                                     brand: "Apple",
                                     category: "Apple",
                                     thumbnail: "",
                                     images: []))
    }
}
