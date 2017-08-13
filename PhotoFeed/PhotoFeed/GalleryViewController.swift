//
//  GalleryViewController.swift
//  PhotoFeed
//
//  Created by Louis W. Haywood on 8/12/17.
//  Copyright © 2017 Louis W. Haywood. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate: class {
    func galleryController(didSelect image: UIImage)
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var delegate: GalleryViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!

    var allPosts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = GalleryFlowLayout(columns: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CloudKit.shared.getPosts {(posts) in
            if let posts = posts {
                print(posts)
                self.allPosts = posts
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        cell.post = self.allPosts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            let selectedPost = self.allPosts[indexPath.row]
            
            delegate.galleryController(didSelect: selectedPost.image)
            
        }
    }
}

