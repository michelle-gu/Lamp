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
import FirebaseFirestore

// MessageKit works with messages that conform to the MessageType protocol
struct Message: MessageType {
    let sender: Sender
    let id: String?
    let content: String
    let sentDate: Date
    
    var kind: MessageKind {
        return .text(content)
    }
    
    // if there isn't an ID yet then make one?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    init(userId: String, content: String) {
        sender = Sender(id: userId, displayName: "")
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Date else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
        } else {
            return nil
        }
    }
//    let userId: String
//    let text: String
//    let messageId: String
//
//    var sender: Sender {
//        return Sender(id: userId, displayName: "")
//    }
//
//    var sentDate: Date {
//        return Date()
//    }
//
//    var kind: MessageKind {
//        return .text(text)
//    }
}

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

extension Message: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.id,
            "senderName": sender.displayName,
            "content": content
        ]
        return rep
    }
}

extension Message: Comparable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}

