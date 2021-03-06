//
//  Filters.swift
//  PhotoFeed
//
//  Created by Louis W. Haywood on 8/5/17.
//  Copyright © 2017 Louis W. Haywood. All rights reserved.
//

import UIKit

typealias FilterCompletion = (UIImage?)->()

enum FilterNames: String{
    case CIPhotoEffectTransfer
    case CIPhotoEffectMono
    case CIPhotoEffectChrome
    case CIColorInvert
    case CISRGBToneCurveToLinear
    case CILinearToSRGBToneCurve
    case CIMedianFilter
    case CIMaskToAlpha
    case CIVignette
    case CIBumpDistortion
    
}


class Filters {

    static var originalImage = UIImage()
    
    static var undoImageFilters = [UIImage]()
        
    class func filter(image: UIImage, withFilter filterName: FilterNames, completion: @escaping FilterCompletion){
        OperationQueue().addOperation {
            guard let filter = CIFilter(name: filterName.rawValue) else {
                fatalError("There is an error with the filter name.")
            }
            let coreImage = CIImage(image: image)
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            //GPU CONTEXT CODE
            let options = [kCIContextOutputColorSpace : NSNull()]
                
            guard let eAGLContext = EAGLContext(api: .openGLES2) else {
                    fatalError("There was an issue accessing the GPU")
            }
            let context = CIContext(eaglContext: eAGLContext, options: options)
                
            //Get final image after being filtered
            if let outputImage = filter.outputImage {
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    OperationQueue.main.addOperation {
                        completion(UIImage(cgImage: cgImage))
                    }
                }
            }
        }
    }
}
