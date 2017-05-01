//
//  FirstViewController.swift
//  JediPointsTracker
//
//  Created by Amanda Chappell on 4/28/17.
//  Copyright © 2017 Amanda Chappell. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users: [User] = []
    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.child("events").observe(.childAdded, with: { (snapshot) in
            self.addEvent(from: snapshot)
        })
        
        ref.child("events").observe(.childRemoved, with: { (snapshot) in
            self.deleteEvent(from: snapshot)
        })
    }
    
    func addEvent(from snapshot: FIRDataSnapshot) {
        let eventValue = snapshot.value as? NSDictionary
        let event = Event(key: snapshot.key, dictionary: eventValue as? [String: Any])
        
        if event.date >= Date().firstDayOfMonth() && event.date < Date().firstDayOfNextMonth() {
            if let user = self.userWithName(event.user) {
                user.events.append(event)
            } else {
                let user = User(name: event.user, events: [event])
                self.users.append(user)
            }
            self.users.sort(by: { (user1, user2) -> Bool in
                user1.totalPoints() > user2.totalPoints()
            })
            self.tableview.reloadData()
        }
    }
    
    func deleteEvent(from snapshot: FIRDataSnapshot) {
        let eventValue = snapshot.value as? NSDictionary
        let event = Event(key: snapshot.key, dictionary: eventValue as? [String: Any])
        
        if let user = self.userWithName(event.user) {
            user.removeEvent(key: event.key)
        }
        
        self.users.sort(by: { (user1, user2) -> Bool in
            user1.totalPoints() > user2.totalPoints()
        })
        self.tableview.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") ?? UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "\(user.totalPoints())"
        return cell
    }
    
    func userWithName(_ name: String) -> User? {
        return users.filter { (user) -> Bool in
            return user.name == name
        }.first
    }
}

extension Date {
    func firstDayOfMonth() -> Date {
        let calendar = NSCalendar.current
        let components: DateComponents = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
    
    func firstDayOfNextMonth() -> Date {
        let calendar = NSCalendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month], from: self)
        if let month = components.month {
            components.month = month + 1
        }
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
}

