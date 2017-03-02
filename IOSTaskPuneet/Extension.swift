//
//  Extension.swift
//  IOSTaskPuneet
//
//  Created by Puneeth Kumar  on 06/01/17.
//  Copyright © 2017 ASM Technologies Limited. All rights reserved.
//

import UIKit

public extension UIButton {
    
    func setFollowButton() {
        self.setTitle("Following", for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor(hexString: "#C7425D")
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#C74s5D")?.cgColor
    }
    
    func setUnFollowButton() {
        self.setTitle("Follow", for: .normal)
        self.setTitleColor(UIColor(hexString: "#C7425D"), for: .normal)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#C7425D")?.cgColor
    }
}


var xoAssociationKey: UInt8 = 0
extension UIButton{
    
    var section: Int?{
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? Int
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
    }
}
