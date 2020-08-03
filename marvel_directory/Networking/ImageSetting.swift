//
//  ImageSetting.swift
//  marvel_directory
//
//  Created by clydies freeman on 8/2/20.
//  Copyright © 2020 clydies freeman. All rights reserved.
//

import Foundation
import UIKit

public final class ImageSetting {
    private enum Constants {
        static let baseURL = "https://image.blockbusterbd.net/00416_main_image_04072019225805.png"
        static let imageViewCorners: CGFloat = 15
    }
    
    class func setCharacterDetailViewImage(imageView: UIImageView, imagePath: String? = nil) {
        guard let imagePath = imagePath else {
            print("image url not working")
            return
            
        }
        
            guard let imageURL = URL(string: imagePath) else {
            print("Url could not be constructed")
            return
        }
        guard let imageData = try? Data(contentsOf: imageURL) else {
            print("data could not be extracted")
            return
        }
        
        DispatchQueue.global().async {
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                imageView.image = image
                imageView.layer.cornerRadius = Constants.imageViewCorners
            }
        }
    }
}
