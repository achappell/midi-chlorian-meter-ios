//
//  User.swift
//  JediPointsTracker
//
//  Created by Amanda Chappell on 4/28/17.
//  Copyright © 2017 Amanda Chappell. All rights reserved.
//

import Foundation

class User {
    let name: String
    var events: [Event] = []
    
    func totalPoints() -> Int {
        return self.events.reduce(0) { (total, event) -> Int in
            return total + event.value
            } 
    }
    
    init(name: String, events: [Event]) {
        self.name = name
        self.events = events
    }
    
    func removeEvent(key: String) {
        self.events = events.filter({ (event) -> Bool in
            event.key != key
        })
    }
}
