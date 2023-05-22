//
//  ProductsViewModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 22/05/2023.
//

import Foundation

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    
    ///📌 Download same random data from (dummyjson) and then upload this data to firestore
    func downloadProductsAndUploadFirebase() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else { return }
                
                let products = try JSONDecoder().decode(ProductArray.self, from: data)
                
                let productsArray = products.products
                
                for product in productsArray {
                    try? await ProductsManager.shared.uploadProduct(product: product)
                }
                
                print("[⚠️] download products: \(products.products.count)")
                
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    ///📌 Download data (all products) back from Firestore collection products
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
    }
    
}
