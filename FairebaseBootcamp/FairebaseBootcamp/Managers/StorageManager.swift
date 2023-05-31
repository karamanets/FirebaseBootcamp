//
//  StorageManager.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 30/05/2023.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    ///📌 Root location of FirebaseStorage
    private let storage = Storage.storage().reference()
    
    ///📌 Folder in root
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    ///📌 Folder with user folder use userId
    private func userReference(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }
    
    ///📌 Get Path for image full path
    private func getPathForImage(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    ///📌 Get URL from path
    private func getUrlForImage(path: String) async throws -> URL {
        try await getPathForImage(path: path).downloadURL()
    }
    
    ///📌 Upload Data to FirebaseStorage
    func saveImage(data: Data) async throws -> (path: String, name: String) {
        
        /// Must have metadata of type upload
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        /// Add path of data
        let path = "\(UUID().uuidString).jpeg"
        let returnMetaData = try await imagesReference.child(path).putDataAsync(data, metadata: meta)
        
        /// Check return value - if doesn't exist -> throw error
        guard
            let returnPath = returnMetaData.path,
            let returnName = returnMetaData.name else {
            throw URLError(.badURL)
        }
        return (returnPath, returnName)
    }
    
    ///📌 Upload Data to FirebaseStorage in user own folder use userId
    func saveImage2(data: Data, userId: String) async throws -> (path: String, name: String) {
        
        /// Must have metadata of type upload
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        /// Add path of data
        let path = "\(UUID().uuidString).jpeg"
        let returnMetaData = try await userReference(userId: userId).child(path).putDataAsync(data, metadata: meta)
        
        /// Check return value - if doesn't exist -> throw error
        guard
            let returnPath = returnMetaData.path,
            let returnName = returnMetaData.name else {
            throw URLError(.badURL)
        }

        return (returnPath, returnName)
    }
    
    ///📌 Upload Image to FirebaseStorage in user own folder use userId convert UImage to Data
    func saveImage(image: UIImage, userId: String) async throws -> (path: String, name: String) {
        ///jpegData or image.pngData()
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.badURL)
        }
        return try await saveImage2(data: data, userId: userId)
    }
    
    ///📌  Get Data form Storage some user folder
    private func getData(userId: String, path: String) async throws -> Data {
       // try await userReference(userId: userId).child(path).data(maxSize: 3 * 1024 * 1024)
        /// Or  full path
        try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    ///📌  Get Image form Storage user folder
    func getImage(userId: String, path: String) async throws -> UIImage {
        let data = try await getData(userId: userId, path: path)
        
        guard let image = UIImage(data: data) else {
            throw URLError(.badURL)
        }
        return image
    }
    
    ///📌 Get url of image use path
    func getUrlFromPath(path: String) async throws -> URL {
        try await Storage.storage().reference(withPath: path).downloadURL()
    }
    
    ///📌 Delete image use Path
    func deleteImage(path: String) async throws {
        try await getPathForImage(path: path).delete()
    }
}
