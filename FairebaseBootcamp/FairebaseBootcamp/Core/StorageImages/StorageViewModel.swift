//
//  StorageViewModel.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 30/05/2023.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class StorageViewModel: ObservableObject {
    
    @Published var image: Image?
    @Published var downloadImage: UIImage?
    @Published var imageUrl: URL?
    
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                try await loadTransferable(from:imageSelection)
            }
        }
    }
    
    ///📌 Get image from local photo
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        Task {
            do {
                if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        self.image = Image(uiImage: uiImage)
                    }
                }
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
                self.image = nil
            }
        }
    }
    
    ///📌 Save Image in Firebase Storage use PhotosPickerItem
    func saveImage(item: PhotosPickerItem) {
        Task {
            do {
                
                ///Convert type into Data
                guard let data = try await item.loadTransferable(type: Data.self) else { return }
                
                ///Get User ID
                let user = try AuthManager.shared.getAuthenticatedUser()
                
                ///Get path of image and name of image
                let (path, _ ) = try await StorageManager.shared.saveImage2(data: data, userId: user.uid)
                
                let url = try await StorageManager.shared.getUrlFromPath(path: path)
                
                ///Save image use Path
                try await UserManager.shared.updateUserImagePath(userId: user.uid, path: path)
                
                ///Save image use URL -> instead Path for example
                try await UserManager.shared.updateUserImageUrl(userId: user.uid, url: url.absoluteString)
                
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
    
    ///📌 Download Image from Firebase Storage use path
    func getImageFromPath() {
        Task {
            do {
                /// Must be in som model instead make new request
                let userId = try AuthManager.shared.getAuthenticatedUser()
                
                /// Must be in som model instead make new request
                let user = try await UserManager.shared.getUser(user: userId.uid)
                
                if let path = user.profileImagePath {
                    downloadImage = try await StorageManager.shared.getImage(userId: userId.uid, path: path)
                }
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
    
    ///📌 Download Image from Firebase Storage use URL
    func getImageFromUrl() {
        Task {
            do {
                /// Must be in som model instead make new request
                let userId = try AuthManager.shared.getAuthenticatedUser()
                
                /// Must be in som model instead make new request
                let user = try await UserManager.shared.getUser(user: userId.uid)
                
                if let url = user.profileImagePathUrl {
                    imageUrl = URL(string: url)
                }
                
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
    
    ///📌 Delete image - can use only path
    func deleteImage() {
        Task {
            do {
                let userId = try AuthManager.shared.getAuthenticatedUser()
                
                /// Must be in som model instead make new request
                let user = try await UserManager.shared.getUser(user: userId.uid)
                
                /// Must be in ViewModel
                if let path = user.profileImagePath {
                    /// Delete use path
                    try await StorageManager.shared.deleteImage(path: path)
                    
                    /// Update UserProfile to delete pat -> it better make in one request
                    try await UserManager.shared.updateUserImagePath(userId: user.userId, path: nil)
                    
                    /// Update UserProfile to delete pat
                    try await UserManager.shared.updateUserImageUrl(userId: user.userId, url: nil)
                    
                    image = nil
                    imageUrl = nil
                    imageSelection = nil
                    downloadImage = nil
                }
            } catch let error {
                print("[⚠️] Error: \(error.localizedDescription)")
            }
        }
    }
}
