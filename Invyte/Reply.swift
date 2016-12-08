//
//  Event.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/18/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class Reply {
    
    var personReplyingID: String
    var reply: String
    
    init(reply: String, personReplyingID: String) {
        self.reply = reply
        self.personReplyingID = personReplyingID
    }
    
    
}
