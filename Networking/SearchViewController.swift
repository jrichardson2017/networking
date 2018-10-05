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

class SearchViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    
    var searchResult = SearchResults()
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        placeTableViewBelowSearchBar()
    }
    
    // MARK: Table View Customizations
    
    func placeTableViewBelowSearchBar() {
        // adjust the content area of the table view so it's below the search bar
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: Networking
    func makeNetworkRequest() {
        // Build the URL
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/course"
        guard let url = URL(string: urlString) else { return }
        // Configure the Request
        let request = URLRequest(url: url)
        // Make the Request
        let session = URLSession.shared
        
         DispatchQueue.global(qos: .userInitiated).async {
            let task = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = `self` else { return }
                
                print("Getting Data...")
                
                guard let data = data else { return }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                print("Request Response: \(statusCode)")
                
                // Parse the Data!
                do {
                    let decoder = JSONDecoder()
                    self.searchResult = try decoder.decode(SearchResults.self, from: data)
                    print("Got Data!")
                } catch let jsonError{
                    print("Error decoding JSON: \(jsonError)")
                }
                
                DispatchQueue.main.async(execute: {
                    print("Reloading Data")
                    self.tableView.reloadData()
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
    // MARK: Number of Rows in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchResults.count
        return 1
    }
    
    // MARK: The reuseable cell in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create the cells reuseable identifier
        let cellIdentifier = "SearchResultCell"
        // Create the cell and assign the identifier to it
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        // Make a backup default cell incase the reuseable cell can't be created
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        // Assign the search results string to the cells text label
        if let name = searchResult.name {
            cell.textLabel?.text = name
        }
        
        return cell
    }
    
    
}
