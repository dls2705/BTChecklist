//
//  Checklist.swift
//  Checklists
//
//  Created by Diego Legua on 26/08/16.
//  Copyright © 2016 DL.Training. All rights reserved.
//

import Foundation

class Checklist {
    var title:String = ""
    var done:Bool = false
    
    init(WithTitle title:String) {
        self.title = title
        self.done = false
    }
}