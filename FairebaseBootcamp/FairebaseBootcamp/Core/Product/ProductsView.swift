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

                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.downloadProductsAndUploadFirebase()
                    } label: {
                        Image(systemName: "tray.and.arrow.down.fill")
                        Text("Download")
                    }
                }
            }
            .task {
                try? await vm.getAllProducts()
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

