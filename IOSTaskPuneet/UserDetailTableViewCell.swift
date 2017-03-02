//
//  UserDetailTableViewCell.swift
//  IOSTaskPuneet
//
//  Created by Puneeth Kumar  on 09/01/17.
//  Copyright © 2017 ASM Technologies Limited. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userName.textColor = UIColor(hexString: "#C7425D")
        self.handleLabel.textColor = UIColor(hexString: "#337ab7")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
