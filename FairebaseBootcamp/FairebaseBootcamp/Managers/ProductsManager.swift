//
//  ProductsManager.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 22/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProductsManager {
    
    static let shared = ProductsManager()
    
    private init() {}
    
    ///📌 Path to products collection
    private let productsCollection = Firestore.firestore().collection("products")
    
    ///📌 Path to product document in product Collection
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    ///📌 Upload product in products collection (use codable protocol)
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    ///📌 Get Single document from products collection (use codable protocol)
    func getSingleProduct(product: Product) async throws -> Product {
        try await productDocument(productId: String(product.id)).getDocument(as: Product.self)
    }
    
    ///📌 Get all documents (product) from products collection (use codable protocol)
    private func getAllProducts() async throws -> [Product] {
        try await productsCollection.getAllDocumentsGeneric(as: Product.self)
    }
    
    ///📌 Filter by price
    private func getAllProductsFilterByPrice(descending: Bool) async throws -> [Product] {
        /// Filter by price descending down or up. (field in firestore)
        try await productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getAllDocumentsGeneric(as: Product.self)
    }
    
    ///📌 Filter by Category
    private func getAllProductsFilterByCategory(category: String) async throws -> [Product] {
        /// Filter by category, there is lat's of options  whereField. isEqualTo or e.s (field in firestore)
        try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .getAllDocumentsGeneric(as: Product.self)
    }
    
    ///📌 Filter by Category and Price at the same time
    private func getAllProductsFilterByPriceAndCategory(category: String, descending: Bool) async throws -> [Product] {
        try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getAllDocumentsGeneric(as: Product.self)
    }
    
    ///📌 Filter by Category or Price or both at the same time
    func getFilteredProducts(forCategory category: String?,forPrice descending: Bool?) async throws -> [Product] {
        ///🔥 if let descending = descending and category = category (long form)
        ///🔥 For combine filters need add  -> query index  (composite) (in cancel get address where add in firestore )
        if let descending, let category {
            return try await getAllProductsFilterByPriceAndCategory(category: category, descending: descending)
        } else if let descending {
            return try await getAllProductsFilterByPrice(descending: descending)
        } else if let category {
            return try await getAllProductsFilterByCategory(category: category)
        }
        return try await getAllProducts()
    }
}

extension Query {
    
    ///📌 Generic func get all documents from collection -> but must be limited if collection has lat's of documents 
    func getAllDocumentsGeneric<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
}
