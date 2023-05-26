//
//  FavoriteView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 26/05/2023.
//

import SwiftUI



@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var product: [(favorite: UserFavoriteModel, product: Product)] = []
    
    @Published private(set) var userFavoriteProducts: [UserFavoriteModel] = []
    
    ///📌 Example 1 Download all Favorites from user subCollection
    func getFavorites_1() {
        Task {
            do {
                /// instead inject user some where
                let user = try AuthManager.shared.getAuthenticatedUser()
                let favorites = try await UserManager.shared.getAllFavoriteUserProduct(userId: user.uid)
            
                var temp: [(favorite: UserFavoriteModel, product: Product)] = []
                
                for favorite in favorites {
                    do {
                        let product = try await ProductsManager.shared.getSingleProduct(productId: String(favorite.productId))
                            temp.append((favorite, product))
                        
                    } catch let error {
                        print("[⚠️] Error: \(error.localizedDescription)")
                    }
                }
                self.product = temp
                
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
    
    ///📌 Example 2 Download all Favorites from user subCollection use -> ProductCellViewBuilder
    func getFavorites_2() {
        Task {
            do {
                /// instead inject user some where
                let user = try AuthManager.shared.getAuthenticatedUser()
                self.userFavoriteProducts = try await UserManager.shared.getAllFavoriteUserProduct(userId: user.uid)
                
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
    
    ///📌 Remove selected item from user subCollection Favorites
    func removeFavorite(favoriteId: String) {
        Task {
            do {
                /// instead inject user some where
                let user = try AuthManager.shared.getAuthenticatedUser()
                try await UserManager.shared.removeUserFavoriteProduct(userId: user.uid, favoriteProductId: favoriteId )
                getFavorites_2()
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
}

struct FavoriteView: View {
    
    @StateObject private var vm = FavoriteViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.userFavoriteProducts, id:\.id.self) { item in
                    ProductCellViewBuilder(productId: String(item.productId))
                        .contextMenu {
                            Button("Remove from Favorite") {
                                vm.removeFavorite(favoriteId: item.id)
                            }
                        }
                }
            }
            .navigationTitle("Favorite")
        }
        .onAppear {
            vm.getFavorites_2()
        }
    }
}

//                  🔱
struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
