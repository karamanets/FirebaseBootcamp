//
//  ProductCellViewBuilder.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 26/05/2023.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    
    @State private var product: Product? = nil
    
    let productId: String
    
    var body: some View {
        ZStack {
            if let product {
                ProductCell(product: product)
            }
        }
        .task {
            do {
                self.product = try await ProductsManager.shared.getSingleProduct(productId: productId)
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
}

//                    🔱
struct ProductCellViewBilder_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellViewBuilder(productId: "1")
    }
}
