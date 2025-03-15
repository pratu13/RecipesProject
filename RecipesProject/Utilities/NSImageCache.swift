//
//  DefaultImageCache.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import UIKit
import Foundation

protocol ImageCache {
    associatedtype CachedImage
    func image(for id: NSString) -> CachedImage?
    func insertImage(_ image: CachedImage?, for id: NSString)
}

class NSImageCache: ImageCache {
    typealias CachedImage = UIImage
    private let cache = NSCache<NSString, UIImage>()
    
    func image(for id: NSString) -> UIImage? {
        return cache.object(forKey: id as NSString)
    }
    
    func insertImage(_ image: UIImage?, for id: NSString) {
        guard let image = image else {
            cache.removeObject(forKey: id as NSString)
            return
        }
        cache.setObject(image, forKey: id as NSString)
    }
}
