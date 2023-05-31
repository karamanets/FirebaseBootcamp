//
//  StorageView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 30/05/2023.
//

import SwiftUI
import PhotosUI

struct StorageView: View {
    
    @StateObject private var vm = StorageViewModel()
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                
                VStack {
                    if let image = vm.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 3,x: 3,y: 3)
                    }
                    
                    Button {
                        if let image = vm.imageSelection {
                            vm.saveImage(item: image)
                        }
                    } label: {
                        Text("Save Image in Storage")
                    }.buttonMode()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                
                VStack {
            
                    if let uiImage = vm.downloadImage {
                        let image = Image(uiImage: uiImage)
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 3,x: 3,y: 3)
                    }
                    
                    Button {
                        vm.getImageFromPath()
                    } label: {
                        Text("Download Image from Storage Path")
                    }.buttonMode()

                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                
                VStack {
                    
                    if let url = vm.imageUrl {
                        AsyncImage(url: url) { Image in
                            Image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 3,x: 3,y: 3)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 300, height: 200)
                        }
                    }
                    
                    Button {
                        vm.getImageFromUrl()
                    } label: {
                        Text("Download Image from Storage URL")
                    }.buttonMode()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                
            }
            .navigationTitle("Storage")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $vm.imageSelection,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Image(systemName: "gear")
                        Text("Get Image")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.deleteImage()
                    } label: {
                        Image(systemName: "trash")
                        Text("Delete")
                    }

                }
            }
        }
    }
}

//                 🔱
struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}
