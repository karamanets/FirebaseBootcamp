//
//  ProductsView_2.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 24/05/2023.
//

import SwiftUI

struct ProductsView_2: View {
    
    @StateObject private var vm = ProductsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.products) { product in
                    
                    ProductCell(product: product)

                }
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                       vm.getProductsByRatingAndAmount()
                    } label: {
                        Image(systemName: "gear")
                        Text("Get More")
                    }
                }
            }
        }
    }
}

//                  🔱
struct ProductsView_2_Previews: PreviewProvider {
    static var previews: some View {
            ProductsView_2()
    }
}

//
//import Foundation
//import FirebaseFirestore
//
//@MainActor
//final class ProductsViewModel: ObservableObject {
//
//    @Published var products: [Product] = []
//    @Published var filterPrice: FiltersPrice? = nil
//    @Published var filterCategory: FilterCategory? = nil
//    @Published var filterRatingAndAmount: [Product] = []
//
//    ///📌 May add struct with DocumentSnapshot that don't import FirebaseFirestore all the time
//    private var last: DocumentSnapshot? = nil
//
//    ///📌 Download same random data from (dummyjson) and then upload this data to firestore
//    func downloadProductsAndUploadFirebase() {
//        guard let url = URL(string: "https://dummyjson.com/products") else { return }
//
//        Task {
//            do {
//                let (data, response) = try await URLSession.shared.data(from: url)
//                guard
//                    let response = response as? HTTPURLResponse,
//                    response.statusCode >= 200 && response.statusCode < 300 else { return }
//
//                let products = try JSONDecoder().decode(ProductArray.self, from: data)
//
//                let productsArray = products.products
//
//                for product in productsArray {
//                    try? await ProductsManager.shared.uploadProduct(product: product)
//                }
//
//                print("[⚠️] download products: \(products.products.count)")
//
//            } catch let error {
//                print("[⚠️] Error: \(error.localizedDescription)")
//            }
//        }
//
//    }
//
//    //MARK: Filters
//    ///📌 Type of filters price
//    enum FiltersPrice: String, CaseIterable {
//        case noFilter
//        case priceHeight
//        case priceLow
//
//        var priceDescending: Bool? {
//            switch self {
//
//            case .noFilter:
//                return nil
//            case .priceHeight:
//                return true
//            case .priceLow:
//                return false
//            }
//        }
//    }
//
//    ///📌 Filter Product Price
//    func selectedFilterPrice(option: FiltersPrice) async throws {
//        self.filterPrice = option
//        self.getProducts()
//    }
//
//    ///📌 Type of filters category
//    enum FilterCategory: String, CaseIterable {
//        /// The name of case must be the same as firestore
//        case noCategory
//        case smartphones
//        case laptops
//        case fragrances
//
//        ///SetUp for noCategory
//        var categoryKey: String? {
//            if self == .noCategory {
//                return nil
//            }
//            return self.rawValue
//        }
//    }
//
//    ///📌 Filter Product  Category
//    func selectedFilterCategories(category: FilterCategory) async throws {
//        self.filterCategory = category
//        self.getProducts()
//    }
//
//    ///📌 Filter Rating and get som amount of downloaded documents with add more (lastRating)
//    func getProductsByRatingAndAmount() {
//        Task {
//            do {
//                self.filterRatingAndAmount = try await ProductsManager.shared.getProductsByRating(count: 3,
//                                                                                                  lastRating: self.filterRatingAndAmount.last?.rating)
//                self.products.append(contentsOf: filterRatingAndAmount)
//            } catch let error {
//                print("[⚠️] Error: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    ///📌 Filter Rating and get som amount of downloaded documents with add more (lastRating) use last snapshot
//    func getProductsByRatingAndAmountWithSnapshot() {
//        Task {
//            do {
//                let (newProduct, lastDocument) = try await ProductsManager.shared.getProductsByRatingWithLastSnapshot(count: 3, lastDocument: last)
//                self.products.append(contentsOf: newProduct)
//                self.last = lastDocument
//            } catch let error {
//                print("[⚠️] Error: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    ///📌 Filter Product Price and Category with count and last snapshot
//    func getProducts() {
//        Task {
//            do {
//                let (newProduct, lastDocument) = try await ProductsManager.shared.getFilteredProducts(forCategory: filterCategory?.categoryKey,
//                                                                                                      forPrice: filterPrice?.priceDescending,
//                                                                                                      count: 7,
//                                                                                                      lastDocument: self.last)
//                self.products.append(contentsOf: newProduct)
//                self.last = lastDocument
//
//            } catch let error {
//                print("[⚠️] Error: \(error.localizedDescription)")
//            }
//        }
//    }
//}
