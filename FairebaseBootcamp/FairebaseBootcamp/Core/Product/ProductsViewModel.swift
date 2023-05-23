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
    @Published var filterPrice: FiltersPrice? = nil
    @Published var filterCategory: FilterCategory? = nil
    
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
    
    //MARK: Filters
    ///📌 Type of filters price
    enum FiltersPrice: String, CaseIterable {
        case noFilter
        case priceHeight
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
                
            case .noFilter:
                return nil
            case .priceHeight:
                return true
            case .priceLow:
                return false
            }
        }
    }
    
    ///📌 Filter Product Price
    func selectedFilterPrice(option: FiltersPrice) async throws {
        self.filterPrice = option
        self.getProducts()
    }
    
    ///📌 Type of filters category
    enum FilterCategory: String, CaseIterable {
        /// The name of case must be the same as firestore
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        ///SetUp for noCategory
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    ///📌 Filter Product Price
    func selectedFilterCategories(category: FilterCategory) async throws {
        self.filterCategory = category
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            do {
                self.products = try await ProductsManager.shared.getFilteredProducts(forCategory: filterCategory?.categoryKey, forPrice: filterPrice?.priceDescending)
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
    
}
