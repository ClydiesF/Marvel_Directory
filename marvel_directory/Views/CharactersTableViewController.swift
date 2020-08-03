//
//  CharactersTableViewController.swift
//  marvel_directory
//
//  Created by clydies freeman on 8/2/20.
//  Copyright © 2020 clydies freeman. All rights reserved.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet var characterBio: UILabel!
    @IBOutlet var characterName: UILabel!
    @IBOutlet var characterImageView: UIImageView!
}

final class CharactersTableViewController: UITableViewController {
    private let fetcher = MarvelHeroFetching()
    private var characterDetails: [CharacterDetails] = []
    
    private enum Constants {
        static let tableViewCellID = "CharacterCell"
        static let cellHieght = 150
        static let CharacterDetailViewSegue = "CharacterDetailViewSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getListOfCharacters()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return characterDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellID, for: indexPath) as! CharacterTableViewCell
        let character = characterDetails[indexPath.row]
        
        cell.characterBio.text = character.description
        cell.characterName.text = character.name
        guard let thumbnailPath = character.thumbnail?.path, let thumbnailExtension = character.thumbnail?.extensionString else { return cell}
        let imagePath = "\(thumbnailPath).\(thumbnailExtension)"
        var newImagePath = imagePath.components(separatedBy: ":")
        newImagePath[0] = "https:"
        let newnew = newImagePath.joined()
        
        
        ImageSetting.setCharacterDetailViewImage(imageView: cell.characterImageView, imagePath: newnew)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.cellHieght)
    }
    
//MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.CharacterDetailViewSegue {
            guard let cell = sender as? CharacterTableViewCell,
                let destination = segue.destination as? CharacterDetailViewController,
                let indexPath = tableView.indexPath(for: cell) else {
                    return
            }
            
            let character = characterDetails[indexPath.row]
            
            destination.cBio = character.description
            destination.cName = character.name
            
            guard let thumbnailPath = character.thumbnail?.path, let thumbnailExtension = character.thumbnail?.extensionString else { return }
            let imagePath = "\(thumbnailPath).\(thumbnailExtension)"
            var newImagePath = imagePath.components(separatedBy: ":")
            newImagePath[0] = "https:"
            let newnew = newImagePath.joined()
            
            destination.imagePath = newnew
        }
    }
}

extension CharactersTableViewController {
    func getListOfCharacters() {
        fetcher.getListOfCharacters { result in
            switch result {
            case let .success(characters):
                self.characterDetails = characters
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                self.displayError(error: error)
            }
        }
    }
    
    func displayError(error: Error) {
        let alert = UIAlertController(title: "Fetch error", message: "Couldnt retrieve media: \(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style: .cancel))
        present(alert, animated: true)
    }
}
