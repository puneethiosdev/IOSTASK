//
//  UserBean.swift
//  IOSTaskPuneet
//
//  Created by Puneeth Kumar  on 09/01/17.
//  Copyright © 2017 ASM Technologies Limited. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class UserBean: NSManagedObject {
    
    @NSManaged var about:String?
    @NSManaged var id:String?
    @NSManaged var username:String?
    @NSManaged var followers:NSNumber?
    @NSManaged var following:NSNumber?
    @NSManaged var image:String?
    @NSManaged var url:String?
    @NSManaged var handle:String?
    @NSManaged var is_following:NSNumber?
    @NSManaged var createdOn:NSNumber?
    
    func initWith(id:String, about:String, username:String, followers:NSNumber, following:NSNumber, image:String, url:String, handle:String, is_following:NSNumber, createdOn:NSNumber) {
        self.about = about
        self.id = id
        self.username = username
        self.followers = followers
        self.following = following
        self.image = image
        self.url = url
        self.handle = handle
        self.is_following = is_following
        self.createdOn = createdOn
    }
    
}
