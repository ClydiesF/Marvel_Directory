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
    @IBOutlet var searchTitle: UILabel!
    
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let errorMessageTitle = "No Query String"
        static let errorMessageBody = "Please type atleast one character to trigger a proper search"
        static let dismissString = "Dismiss"
        static let segue = "SearchQuerySegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        searchBar.delegate = self
        searchBar.layer.cornerRadius = Constants.cornerRadius
        browseButton.layer.cornerRadius = Constants.cornerRadius
        searchTitle.layer.cornerRadius = Constants.cornerRadius
        searchTitle.clipsToBounds = true
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
         self.tabBarController?.tabBar.isHidden = false
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        
        if searchBarText.isEmpty {
            let alert = UIAlertController(title: Constants.errorMessageTitle, message: Constants.errorMessageBody, preferredStyle: .alert)
            alert.addAction(.init(title: Constants.dismissString, style: .cancel))
            present(alert, animated: true)
        } else {
            performSegue(withIdentifier: Constants.segue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let searchBarText = searchBar.text else { return }
        
        if segue.identifier == Constants.segue {
            guard let destination = segue.destination as? CharactersTableViewController else { return }
            destination.queryString = searchBarText
        }
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
