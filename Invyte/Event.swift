//
//  Event.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/18/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class Event {
    
    var titleAndDescription: String!
    var creatorID: String!
    
    init(creatorID: String, eventTitleAndDescription: String) {
        self.titleAndDescription = eventTitleAndDescription
        self.creatorID = creatorID
    }
    
    
}
