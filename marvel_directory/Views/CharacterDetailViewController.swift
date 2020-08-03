//
//  CharacterDetailViewController.swift
//  marvel_directory
//
//  Created by clydies freeman on 8/2/20.
//  Copyright © 2020 clydies freeman. All rights reserved.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    var cName: String?
    var cBio: String?
    var imagePath: String?
    
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var characterName: UILabel!
    @IBOutlet var characterBio: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterName.text = cName
        characterBio.text = cBio
        // Do any additional setup after loading the view.
        ImageSetting.setCharacterDetailViewImage(imageView: characterImageView, imagePath: imagePath)
    }
}
