//
//  StoryDetailTableViewCell.swift
//  IOSTaskPuneet
//
//  Created by Puneeth Kumar  on 06/01/17.
//  Copyright © 2017 ASM Technologies Limited. All rights reserved.
//

import UIKit

class StoryDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyDescription: UILabel!
    @IBOutlet weak var verbLabel: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.storyTitleLabel?.textColor = UIColor(hexString: "#C7425D")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
