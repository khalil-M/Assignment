//
//  AssignmentCellTableViewCell.swift
//  Assignment
//
//  Created by Khalil Mhelheli on 13/4/2023.
//

import UIKit

class AssignmentCellTableViewCell: UITableViewCell {
    
    @IBOutlet var devNameLabel: UILabel!
    @IBOutlet var tagsLabel: UILabel!
    @IBOutlet var statusImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
