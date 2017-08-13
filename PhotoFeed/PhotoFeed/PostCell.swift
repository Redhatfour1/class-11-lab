//
//  PostCell.swift
//  PhotoFeed
//
//  Created by Louis W. Haywood on 8/12/17.
//  Copyright © 2017 Louis W. Haywood. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    var post: Post! {
        didSet {
            self.postImageView.image = post.image
        }
    }
}
