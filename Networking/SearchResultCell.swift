//
//  SearchResultCell.swift
//  Networking
//
//  Created by Justin Richardson on 2018-10-04.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var artworkImage: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var artistLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
