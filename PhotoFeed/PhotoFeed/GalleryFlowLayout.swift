//
//  GalleryFlowLayout.swift
//  PhotoFeed
//
//  Created by Louis W. Haywood on 8/12/17.
//  Copyright © 2017 Louis W. Haywood. All rights reserved.
//

import UIKit

class GalleryFlowLayout: UICollectionViewFlowLayout {
    var columns: Int
    let spacing: CGFloat = 1
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
 
    var itemWidth: CGFloat {
        let availableWidth = screenWidth - (CGFloat(self.columns) * self.spacing)
        return availableWidth / CGFloat(self.columns)
    }
    
    init(columns: Int) {
        self.columns = columns
        
        super.init()
        self.minimumLineSpacing = spacing
        self.minimumInteritemSpacing = spacing
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
