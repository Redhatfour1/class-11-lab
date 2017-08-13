//
//  HomeViewController.swift
//  PhotoFeed
//
//  Created by Louis W. Haywood on 8/5/17.
//  Copyright © 2017 Louis W. Haywood. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GalleryViewControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var leadingConstraintForFilterButton: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintForPostButton: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintForUndoButton: NSLayoutConstraint!
    
    let kAnimationTime = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarController = self.tabBarController, let viewControllers = tabBarController.viewControllers {
            
            for viewController in viewControllers {
                if let galleryController = viewController as? GalleryViewController {
                    galleryController.delegate = self
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.selectedImageView.image != nil{
            animateInButtons()
        }
    }
    
    @IBAction func userTappedImage(_ sender: Any) {
//        presentImagePicker(sourceType: .photoLibrary)
        presentAlertController()
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        if let newImage = self.selectedImageView.image {
            let newPost = Post (image: newImage)
            
            CloudKit.shared.save(post: newPost, completion: { (success) in
                if success {
                    print("Successfully saved to the Cloud!")
                } else {
                    print("Unsuccessful in saving to the Cloud!")
                }
                
            })
        }
    }
    
    @IBAction func undoButtonPressed(_ sender: Any) {
        if Filters.undoImageFilters.count > 0 {
            if self.selectedImageView.image == Filters.undoImageFilters.last
            {
        Filters.undoImageFilters.removeLast()
            }
            self.selectedImageView.image = Filters.undoImageFilters.last
        } else {
            self.selectedImageView.image = Filters.originalImage
        
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Filters", message: "Please Select a filter:", preferredStyle: .alert)
        
//DRY CODE BELOW BUT UNORDERED
//        let allFilters = ["Chrome" : FilterNames.CIPhotoEffectChrome,
//                          "Black and White" : FilterNames.CIPhotoEffectMono,
//                          "Vintage" : FilterNames.CIPhotoEffectTransfer,
//                          "Tone Curve" : FilterNames.CILinearToSRGBToneCurve]
//        
//        for (key, value) in allFilters {
//            let alertAction = alertActionForFilter(name: value, title: key)
//            alertController.addAction(alertAction)
//        }
        
        let chromeAction = UIAlertAction(title: "Chrome", style: .default) { (action) in
            if let imageViewImage = self.selectedImageView.image {
                Filters.filter(image: imageViewImage, withFilter: .CIPhotoEffectChrome, completion:{ (filteredImage) in
                    self.selectedImageView.image = filteredImage
                })
            }
        }
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
            if let imageViewImage = self.selectedImageView.image {
                Filters.filter(image: imageViewImage, withFilter: .CIPhotoEffectTransfer, completion:{ (filteredImage) in
                    self.selectedImageView.image = filteredImage
                })
            }
        }
        let blackAndWhiteAction = UIAlertAction(title: "Black and White", style: .default) { (action) in
            if let imageViewImage = self.selectedImageView.image {
                Filters.filter(image: imageViewImage, withFilter: .CIPhotoEffectMono, completion:{ (filteredImage) in
                    self.selectedImageView.image = filteredImage
                })
            }
        }
        let toneCurveAction = UIAlertAction(title: "Tone Curve", style: .default) { (action) in
            if let imageViewImage = self.selectedImageView.image {
                Filters.filter(image: imageViewImage, withFilter: .CILinearToSRGBToneCurve, completion:{ (filteredImage) in
                    self.selectedImageView.image = filteredImage
                })
            }
        }
        let colorCurveAction = UIAlertAction(title: "Color Curve", style: .default) { (action) in
            if let imageViewImage = self.selectedImageView.image {
                Filters.filter(image: imageViewImage, withFilter: .CISRGBToneCurveToLinear, completion:{ (filteredImage) in
                    self.selectedImageView.image = filteredImage
                })
            }
        }
        let invertAction = UIAlertAction(title: "Invert", style: .default) { (action) in
            if let imageViewImage = self.selectedImageView.image {
                Filters.filter(image: imageViewImage, withFilter: .CIColorInvert, completion:{ (filteredImage) in
                    self.selectedImageView.image = filteredImage
                })
            }
        }
        
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(chromeAction)
        alertController.addAction(vintageAction)
        alertController.addAction(toneCurveAction)
        alertController.addAction(invertAction)
        alertController.addAction(colorCurveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertController() {
        
        let alertController = UIAlertController(title: "Select Source", message: "Please select the source for your image!", preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: self.selectedImageView.frame.size.width, height: self.selectedImageView.frame.size.height)
        
        alertController.addAction(cancelAction)
        alertController.addAction(photoLibraryAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType){
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.selectedImageView.image = image
            self.selectedImageView.backgroundColor = UIColor.white
            Filters.originalImage = image
            Filters.undoImageFilters.append(image)
            print(image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(didSelect image: UIImage) {
        self.selectedImageView.image = image
        self.tabBarController?.selectedIndex = 0
    }
    
    func animateInButtons(){
        self.leadingConstraintForFilterButton.constant = 0
        self.trailingConstraintForPostButton.constant = 0
        self.bottomConstraintForUndoButton.constant = 0
            
        UIView.animate(withDuration: kAnimationTime) {
            self.view.layoutIfNeeded()
            self.selectedImageView.layer.cornerRadius = 100
        }
    }
}
