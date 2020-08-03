//
//  ViewController.swift
//  marvel_directory
//
//  Created by clydies freeman on 7/31/20.
//  Copyright © 2020 clydies freeman. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var browseButton: UIButton!
    
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let errorMessageTitle = "No Query String"
        static let errorMessageBody = "Please type atleast one character to trigger a proper search"
        static let dismissString = "Dismiss"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.layer.cornerRadius = Constants.cornerRadius
        browseButton.layer.cornerRadius = Constants.cornerRadius
        
        hideKeyboardWhenTappedAround()
    }
}

//SearchQuerySegue
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        
        if searchBarText.isEmpty {
            let alert = UIAlertController(title: Constants.errorMessageTitle, message: Constants.errorMessageBody, preferredStyle: .alert)
            alert.addAction(.init(title: Constants.dismissString, style: .cancel))
            present(alert, animated: true)
        } else {
            performSegue(withIdentifier: "SearchQuerySegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is Chara
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

