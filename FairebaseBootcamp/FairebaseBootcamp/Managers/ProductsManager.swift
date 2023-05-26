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
        try productDocument(productId: String(product.id))
            .setData(from: product, merge: false)
    }
    
    ///📌 Get Single document from products collection (use codable protocol)
    func getSingleProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId)
            .getDocument(as: Product.self)
    }
    
    ///📌 Get all documents (product) from products collection
    private func getAllProductsQuery() -> Query {
        productsCollection
    }
    
    ///📌 Sort by price
    private func getAllProductsFilterByPriceQuery(descending: Bool) -> Query {
        /// Filter by price descending down or up. (field in firestore)
        productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    ///📌 Sort by Category
    private func getAllProductsFilterByCategoryQuery(category: String) -> Query {
        /// Filter by category, there is lat's of options  whereField. isEqualTo or e.s (field in firestore)
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    ///📌 Sort by Category and Price at the same time
    private func getAllProductsFilterByPriceAndCategoryQuery(category: String, descending: Bool) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    ///📌 Sort by Category or Price or both at the same time with last Snapshot
    func getAllProducts(forCategory category: String?, forPrice descending: Bool?, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        
        ///🔥 if let descending = descending and category = category (long form)
        ///🔥 For combine filters need add  -> query index  (composite) (in cancel get address where add in firestore )
        
        var query: Query = getAllProductsQuery()
        
        if let descending, let category {
            query = getAllProductsFilterByPriceAndCategoryQuery(category: category, descending: descending)
        } else if let descending {
            query = getAllProductsFilterByPriceQuery(descending: descending)
        } else if let category {
            query = getAllProductsFilterByCategoryQuery(category: category)
        }
        
        ///🔥 If in collection documents more then 10 fetch -> 10 ( or oder logic)
        let count = try await productsCollection
            .getAggregationCount()
        
        return try await query
            .limit(to: count > 10 ? 10 : count)
            .start(afterDocumentCustom: lastDocument)
            .getAllDocumentsGenericWithSnapshot(as: Product.self)
    }
    
    ///📌 Sort by rating and add count -> how many documents to get
    func getProductsByRating(count: Int, lastRating: Double?) async throws -> [Product] {
        try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)          //🔥 get limit of documents in collection
            //.limit(toLast: 5)        //🔥 get las of document in collection
            //.start(at: [4.5])        //🔥 start at rating - 4.5
            .start(after: [lastRating ?? 999_999])    //🔥 start at
            .getAllDocumentsGeneric(as: Product.self)
    }
    
    ///📌 Sort by rating and add count -> how many documents to get and get next amount from last document
    func getProductsByRatingWithLastSnapshot(count: Int,
                                             lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        
        return try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(afterDocumentCustom: lastDocument)
            .getAllDocumentsGenericWithSnapshot(as: Product.self)
    }
}

extension Query {
    
    ///📌 Generic func get all documents from collection -> but must be limited if collection has lat's of documents 
//    func getAllDocumentsGeneric<T>(as type: T.Type) async throws -> [T] where T: Decodable {
//
//        let snapshot = try await self.getDocuments()
//
//        return try snapshot.documents.map({ document in
//            try document.data(as: T.self)
//        })
//    }
    
    ///📌 Combine Example of first methods
    func getAllDocumentsGeneric<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        try await getAllDocumentsGenericWithSnapshot(as: type).products
    }
    
    ///📌 Generic func get all documents from collection with last document
    func getAllDocumentsGenericWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
        
        let snapshot = try await self.getDocuments()
        
        let product = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (product, snapshot.documents.last)
    }
    
    ///📌 Custom version of start.(afterDocument: ) with lastDocument optional
    func start(afterDocumentCustom lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    ///📌 Get number of document in collection
    func getAggregationCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
}
