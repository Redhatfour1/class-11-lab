//
//  UIExtension.swift
//  PhotoFeed
//
//  Created by Louis W. Haywood on 8/5/17.
//  Copyright © 2017 Louis W. Haywood. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.draw(in: newRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func path() -> URL {
        guard let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Error accessing Documents Directory.") }
        
        return documentDirectories.appendingPathComponent("image")
    }
}
