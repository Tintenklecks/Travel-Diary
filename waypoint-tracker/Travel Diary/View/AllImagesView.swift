//
//  AllImagesView.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 30.07.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import CoreLocation
import PhotosUI
import SwiftUI

struct AllImagesView: View {
    var start: Date = Date(timeIntervalSinceNow: -900000)
    var end: Date = Date()

    @State var imageIds: [String] = []
    @State var smallImages: [String: UIImage] = [:]
    @State var bigImages: [String: UIImage] = [:]
    
    var body: some View {
        ScrollView {
            ForEach(self.imageIds, id: \.self) { idPhoto in
                HStack {
                    Text("sdfsdfsd")

                    VStack {
                        Image(uiImage: self.smallImages[idPhoto] ?? UIImage(named: "nopic")!)
                        Text(idPhoto)
                    }
                    VStack {
                        Image(uiImage: self.bigImages[idPhoto] ?? UIImage(named: "nopic")!)
                        Text(idPhoto)
                    }
                }
            }
        }
        .onAppear {
            let fetchOptions = PHFetchOptions()

            fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", self.start as NSDate, self.end as NSDate)
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.version = .current
            options.isSynchronous = true
            options.isNetworkAccessAllowed = true

            for index in 0..<assets.count {
                let asset = assets[index]
                
                self.imageIds.append(asset.localIdentifier)
                
                manager.requestImage(for: asset, targetSize: CGSize(width: 30, height: 30), contentMode: .aspectFit, options: options) { image, whatsoever in
                    if let image = image {
                        self.smallImages [asset.localIdentifier] = image
                    }
                }

                
                manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: options) { image, whatsoever in
                    if let image = image {
                        self.bigImages[asset.localIdentifier] = image
                    }
                }

            }
        }
    }
}

struct AllImagesView_Previews: PreviewProvider {
    static var previews: some View {
        AllImagesView()
    }
}
