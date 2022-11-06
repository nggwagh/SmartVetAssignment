//
//  LazyImageView.swift
//  SmartVetAssignment
//
//  Created by NWagh on 05/11/22.
//

import Foundation
import UIKit

class LazyImageView: UIImageView {
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(fromURL imageURL: URL) {
        self.image = UIImage(named: Constants.placeholderImage)
        if let cachedImage  = self.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
                self?.image = image
            }
        }
    }
}
