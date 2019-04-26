//
//  Message.swift
//  Lamp
//
//  Created by Lindsey Thompson on 4/18/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Member {
    let memberID: String
    let name: String
}

// MessageKit works with messages that conform to the MessageType protocol
struct Message: MessageType {
    
    let member: Member
    let text: String
    let messageId: String
    
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
