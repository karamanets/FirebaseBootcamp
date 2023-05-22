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
    func getAllProducts() async throws -> [Product] {
        
        try await productsCollection.getAllDocumentsGeneric(as: Product.self)
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
