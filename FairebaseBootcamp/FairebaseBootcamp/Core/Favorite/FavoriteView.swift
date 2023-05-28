//
//  FavoriteView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 26/05/2023.
//

import SwiftUI
import Combine


@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var product: [(favorite: UserFavoriteModel, product: Product)] = []
    
    @Published private(set) var userFavoriteProducts: [UserFavoriteModel] = []
    
    var cancelable = Set<AnyCancellable>()
    
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
    
    ///📌 Use listeners -> update all the time in real time
    func addListenerFavorite() {
        guard let user = try? AuthManager.shared.getAuthenticatedUser() else { return }
        
        ///Example 1
//        UserManager.shared.addListenerFavoriteUserProduct(userId: user.uid) { [weak self] product in
//            self?.userFavoriteProducts = product
//        }
        
        ///Example 2
        //UserManager.shared.addListenerFavoriteUserProductUseCustomPublisher(userId: user.uid)
        
        ///Example 3
        UserManager.shared.addListenerFavoriteUserProductUseCustomPublisherGeneric(userId: user.uid)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("[⚠️] Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] product in
                self?.userFavoriteProducts = product
            }.store(in: &cancelable)
    }
    
    ///📌 Remove selected item from user subCollection Favorites
    func removeFavorite(favoriteId: String) {
        Task {
            do {
                /// instead inject user some where
                let user = try AuthManager.shared.getAuthenticatedUser()
                try await UserManager.shared.removeUserFavoriteProduct(userId: user.uid, favoriteProductId: favoriteId )
                //getFavorites_2() instead listener
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
}

struct FavoriteView: View {
    
    @StateObject private var vm = FavoriteViewModel()
    @State private var isAppear: Bool = false
    
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
        .onFirstAppear {
            vm.addListenerFavorite()
        }
    }
}

//                  🔱
struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}


//MARK: Custom modifier for -> perform onFirst time appear
struct OnFirstAppear: ViewModifier {
    
    @State private var didAppear: Bool = false
    
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppear(perform: perform))
    }
}
