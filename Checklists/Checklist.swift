//
//  Checklist.swift
//  Checklists
//
//  Created by Diego Legua on 26/08/16.
//  Copyright © 2016 DL.Training. All rights reserved.
//

import Foundation

class Checklist: NSObject, NSCoding {
    
    let titleKey = "Title"
    let doneKey = "Done"
    
    var title:String = ""
    var done:Bool = false
    
    init(WithTitle title:String) {
        self.title = title
        self.done = false
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init()
        title = aDecoder.decodeObjectForKey(titleKey) as! String
        done = aDecoder.decodeBoolForKey(doneKey)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: titleKey)
        aCoder.encodeBool(done, forKey: doneKey)
    }
}