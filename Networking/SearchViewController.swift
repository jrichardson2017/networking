//
//  SearchViewController.swift
//  Networking
//
//  Created by Justin Richardson on 2018-09-20.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        placeTableViewBelowSearchBar()
    }
    
    // MARK: Table View Customizations
    
    func placeTableViewBelowSearchBar() {
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: Networking
    
    func freshbooksURL(searchText: String) -> URL {
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", searchText)
        let url = URL(string: urlString)
        return url!
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            print("The search bar text is: '\(searchText)'")
        } else {
            print("No text in search bar")
        }
    }
}
