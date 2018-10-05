//
//  SearchViewController.swift
//  Networking
//
//  Created by Justin Richardson on 2018-09-20.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

struct SearchResults: Decodable {
    var id: Int?
    var name: String?
    var link: String?
    var imageURL: String?
    var number_of_lessons: Int?
}

struct TableViewCellIdentifiers {
    static var searchResultCell = "SearchResultCell"
    static var nothingFoundCell = "NothingFoundCell"
}

class SearchViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    
    var searchResult = [SearchResults]()
    let dispatchGroup = DispatchGroup()
    var hasSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTableViewAppearance()
        registerNibs()
    }
    
    // MARK: Table View Customizations
    
    func customizeTableViewAppearance() {
        // adjust the content area of the table view so it's below the search bar
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
    }
    
    // MARK: Networking
    func makeNetworkRequest() {
        // Build the URL
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
        guard let url = URL(string: urlString) else { return }
        // Configure the Request
        let request = URLRequest(url: url)
        // Make the Request
        let session = URLSession.shared
        
         DispatchQueue.global(qos: .userInitiated).async {
            let task = session.dataTask(with: request) { [weak self] (data, response, error) in
                
                print("Getting Data...")
                
                guard let data = data else { return }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                print("Request Response: \(statusCode)")
                
                // Parse the Data!
                do {
                    let decoder = JSONDecoder()
                    self?.searchResult = try decoder.decode([SearchResults].self, from: data)
                    print("Got Data!")
                } catch let jsonError{
                    print("Error decoding JSON: \(jsonError)")
                }
                
                DispatchQueue.main.async(execute: {
                    print("Reloading Data")
                    self?.tableView.reloadData()
                })
            }
            // Start the Request
            task.resume()
        }
        
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    // MARK: Begin Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // make network request
        makeNetworkRequest()
        // Dismiss the keyboard once the search button is selected
        searchBar.resignFirstResponder()
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Register Nibs
    func registerNibs() {
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    }
    
    // MARK: Number of Rows in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResult.count == 0 {
            return 1
        } else {
            return searchResult.count
        }
    }
    
    // MARK: The reuseable cell in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchResult.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath) as! NothingFoundCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell

            let result = searchResult[indexPath.row]
            if let name = result.name {
                cell.nameLabel?.text = name
            }
            return cell
        }
    }
    
    
}
