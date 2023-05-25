//
//  ProductsView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 22/05/2023.
//

import SwiftUI

struct ProductsView: View {
    
    @StateObject private var vm = ProductsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.products) { product in
                    
                    ProductCell(product: product)
                    
                    if product == vm.products.last {
                        ProgressView()
                            .onAppear {
                               vm.getProducts()
                                //print("[🔥] Get Next 7 document")
                            }
                    }
                }
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.downloadProductsAndUploadFirebase()
                    } label: {
                        Image(systemName: "tray.and.arrow.down.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Price: \(vm.filterPrice?.rawValue ?? "non")") {
                        ForEach(ProductsViewModel.FiltersPrice.allCases, id: \.self) { filter in
                            Button {
                                Task {
                                    do {
                                        try await vm.selectedFilterPrice(option: filter)
                                    } catch let error {
                                        print("[⚠️] Error: \(error.localizedDescription)")
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "camera.filters")
                                    Text(filter.rawValue)
                                }
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Category: \(vm.filterCategory?.rawValue ?? "non")") {
                        ForEach(ProductsViewModel.FilterCategory.allCases, id: \.self) { category in
                            Button {
                                Task {
                                    do {
                                        try await vm.selectedFilterCategories(category: category)
                                    } catch let error {
                                        print("[⚠️] Error: \(error.localizedDescription)")
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "camera.filters")
                                    Text(category.rawValue)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                vm.getProducts()
            }
        }
    }
}

//                  🔱
struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
            ProductsView()
    }
}

