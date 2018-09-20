//
//  SearchViewController.swift
//  Networking
//
//  Created by Justin Richardson on 2018-09-20.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func freshbooksURL(searchText: String) -> URL {
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", searchText)
        let url = URL(string: urlString)
        return url!
    }

}

