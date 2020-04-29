//
//  TitleTableViewCell.swift
//  BroadcastTVApp
//
//  Created by Vadde Narendra on 4/14/20.
//  Copyright © 2020 Narendra Vadde. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
