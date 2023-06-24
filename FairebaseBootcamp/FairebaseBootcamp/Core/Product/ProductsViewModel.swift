//
//  ProductsViewModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 22/05/2023.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var filterPrice: FiltersPrice? = nil
    @Published var filterCategory: FilterCategory? = nil
    
    var lastDocument: DocumentSnapshot? = nil
    
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
                
            } catch {
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
        self.products = []       /// Reset when setUp new filter
        self.lastDocument = nil  /// Reset when setUp new filter
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
    
    ///📌 Filter Product  Category
    func selectedFilterCategories(category: FilterCategory) async throws {
        self.filterCategory = category
        self.products = []       /// Reset when setUp new filter
        self.lastDocument = nil  /// Reset when setUp new filter
        self.getProducts()
    }
    
    ///📌 Filter Product Price and Category with last Snapshots
    func getProducts() {
        Task {
            do {
                let (newProduct, lastDocument) = try await ProductsManager.shared.getAllProducts(forCategory: filterCategory?.categoryKey,
                                                                                                 forPrice: filterPrice?.priceDescending,
                                                                                                 lastDocument: lastDocument)
                self.products.append(contentsOf: newProduct)
                
                /// if there is last snapshot -> setUp new if not keep last
                if let lastDocument = lastDocument {
                    self.lastDocument = lastDocument
                }
                
            } catch {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Product view 2
    ///📌 Filter Rating and get som amount of downloaded documents with add more (lastRating)
    func getProductsByRatingAndAmount() {
        Task {
            do {
            
                let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRatingWithLastSnapshot(count: 10,
                                                                                                                       lastDocument: lastDocument)
                self.products.append(contentsOf: newProducts)
                if let lastDocument {
                    self.lastDocument = lastDocument
                }
            } catch {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
    
    ///📌 Add Favorite product
    func addFavoriteProduct(productId: Int) {
        Task {
            do {
                /// get user id
                let user = try AuthManager.shared.getAuthenticatedUser()
                try await UserManager.shared.addUserFavoriteProduct(userId: user.uid, productId: productId)
            } catch {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
}

