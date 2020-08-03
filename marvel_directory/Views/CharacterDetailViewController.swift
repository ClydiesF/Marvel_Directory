//
//  CharacterDetailViewController.swift
//  marvel_directory
//
//  Created by clydies freeman on 8/2/20.
//  Copyright © 2020 clydies freeman. All rights reserved.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    var charName: String?
    var charBio: String?
    var imagePath: String?
    var eventNames: EventList? = nil
    
    @IBOutlet var eventString: UILabel!
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var characterName: UILabel!
    @IBOutlet var characterBio: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Character Details"
        characterName.text = charName
        characterName.layer.cornerRadius = 20
        characterName.clipsToBounds = true
        characterBio.text = charBio
        
        if let events = eventNames?.items {
            if events.isEmpty {
                eventString.text = "No Events Available"
            } else {
                var eventsummary: String = ""
                for (i,_) in (0...3).enumerated() {
                    eventsummary += "\(events[i].name ?? ""), "
                }
                eventString.text = eventsummary
            }
        }
        
        ImageSetting.setCharacterDetailViewImage(imageView: characterImageView, imagePath: imagePath)
    }
}
