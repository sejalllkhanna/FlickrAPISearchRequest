//
//  CacheImages.swift
//  SearchFieldNetworkRequest
//
//  Created by Apple on 05/12/21.
//

import UIKit
import Foundation

class CustomImageView: UIImageView {
    
    // MARK: - Constants
    
    let imageCache = NSCache<NSString, AnyObject>()
    public var task: URLSessionDataTask?
    // MARK: - Properties
    
    var imageURLString: String?
    
    func downloadImageFrom(urlString: String, imageMode: UIView.ContentMode) {
        guard let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url, imageMode: imageMode)
    }
    
    func downloadImageFrom(url: URL, imageMode: UIView.ContentMode) {
        contentMode = imageMode
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self.image = imageToCache
                }
            }
            task?.resume()
        }
    }
}
