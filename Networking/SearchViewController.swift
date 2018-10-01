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
    
    // MARK: Variables
    
    var searchResults = [String]()

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
        searchBar.resignFirstResponder()
        searchResults = []
        for i in 0...2 {
            searchResults.append(String(format: "Fake Results '%d' for '%@'", i , searchBar.text!))
        }
        tableView.reloadData()
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SearchResultCell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell.textLabel?.text = searchResults[indexPath.row]
        
        return cell
    }
    
    
}
