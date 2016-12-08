//
//  User.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/18/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class User {
    
    var username: String!
    var email: String!
    var id: String!
    var oneSignalID: String!
    var name: String!
    
    init(username: String, userEmail: String, userID: String, oneSignalID: String, name: String) {
        self.email = userEmail
        self.id = userID
        self.username = username
        self.oneSignalID = oneSignalID
        self.name = name
    }
    
}
