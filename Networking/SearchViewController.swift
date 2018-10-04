//
//  SearchViewController.swift
//  Networking
//
//  Created by Justin Richardson on 2018-09-20.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

struct Course: Decodable {
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
    
    var searchResults = [String]()

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
        // 1. Set the Parameters
        
        // 2. Build the URL
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/course"
        guard let url = URL(string: urlString) else {return}
        // 3. Configure the Request
        let request = URLRequest(url: url)
        // 4. Make the Request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {return}
//            guard let dataString = String(data: data, encoding: .utf8) else {return}
//            print("Request Data: \(dataString)")
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {return}
            print("Request Response: \(statusCode)")
            
            // 5. Parse the Data!
            do {
                let decoder = JSONDecoder()
                let course = try decoder.decode(Course.self, from: data)
            } catch let jsonError{
                print("Error decoding JSON: \(jsonError)")
            }
            // 6. Use the Data!!
        }
        // 7. Start the Request
        task.resume()
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    // MARK: Begin Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // make network request
        makeNetworkRequest()
        // Dismiss the keyboard once the search button is selected
        searchBar.resignFirstResponder()
        // Create an empty array to hold the search results
        searchResults = []
        
        // loop through the results and add each result to the searchResults array
        for i in 0...2 {
            searchResults.append(String(format: "Fake Results '%d' for '%@'", i , searchBar.text!))
        }
        // reload the table so it displays the search results
        tableView.reloadData()
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Number of Rows in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
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
        cell.textLabel?.text = searchResults[indexPath.row]
        
        return cell
    }
    
    
}
