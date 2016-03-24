//
//  MovieTableViewCell.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/23/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func movieTitleSet(title: String) {
        movieTitle.text = title
    }

}
