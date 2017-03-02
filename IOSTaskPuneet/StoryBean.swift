//
//  StoryBean.swift
//  IOSTaskPuneet
//
//  Created by Puneeth Kumar  on 09/01/17.
//  Copyright © 2017 ASM Technologies Limited. All rights reserved.
//

import UIKit

class StoryBean: NSObject {
    
    var descriptn:String?
    var id:String?
    var verb:String?
    var db:String?
    var url:String?
    var si:String?
    var type:String?
    var title:String?
    var like_flag:Bool?
    var likes_count:Int?
    var comment_count:Int?
    var author:UserBean?
    
    func initWith(descriptn:String, id:String, verb:String, db:String, url:String, si:String, type:String, title:String, like_flag:Bool, likes_count:Int, comment_count:Int) {
        self.descriptn = descriptn
        self.id = id
        self.verb = verb
        self.db = db
        self.url = url
        self.si = si
        self.type = type
        self.title = title
        self.like_flag = like_flag
        self.likes_count = likes_count
        self.comment_count = comment_count
    }
    
}
