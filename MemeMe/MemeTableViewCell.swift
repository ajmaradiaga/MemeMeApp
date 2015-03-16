//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Antonio Maradiaga on 14/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layoutSubViews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRectMake(0, 0, 150, 150)
    }

}
