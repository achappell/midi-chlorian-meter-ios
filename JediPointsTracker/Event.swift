//
//  Event.swift
//  JediPointsTracker
//
//  Created by Amanda Chappell on 4/28/17.
//  Copyright © 2017 Amanda Chappell. All rights reserved.
//

import Foundation

struct Event {
    let date: Date
    let note: String?
    let task: Int
    let user: String
    let value: Int
    let key: String
    
    init(key: String, dictionary: [String: Any]?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let dateString = dictionary?["date"] as? String {
            date = dateFormatter.date(from: dateString) ?? Date()
        } else {
            date = Date()
        }
        note = dictionary?["note"] as? String
        task = dictionary?["task"] as? Int ?? 0
        user = dictionary?["user"] as? String ?? ""
        value = dictionary?["value"] as? Int ?? 0
        self.key = key
    }
}
