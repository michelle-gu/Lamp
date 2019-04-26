//
//  MessageInstanceViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/25/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import MessageInputBar

class MessageInstanceViewController: MessagesViewController {

    var profileRef: DatabaseReference!
    let db = Database.database()

    var messages: [Message] = []
    var member: Member!
    var member2: Member!
    var member3: Member!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up current profile info
        profileRef = Database.database().reference(withPath: "user-profiles")
        let user = Auth.auth().currentUser?.uid
        let profile = profileRef.child(user!).child("profile")

//        profile.observe(.value, with: { (snapshot) in
//            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
//
//            // set channel title
//            let profileName = profileDict["firstName"] as! String
//            self.member = Member(memberID: user ?? "no user id", name: profileName, color: .blue)
//
//            let myMessage = Message(member: self.member, text: "Hello!!", messageId: UUID().uuidString)
//            self.insertNewMessage(myMessage)
//
//        })

        member = Member(memberID: "profile-id", name: "Jessica")
        let testMessage = Message(member: member, text: "This is my message", messageId: UUID().uuidString)
        
        member2 = Member(memberID: "profile-id2", name: "James")
        let testMessage2 = Message(member: member2, text: "Hey!", messageId: UUID().uuidString)
        
        member3 = Member(memberID: "profile-id3", name: "Frannie")
        let testMessage3 = Message(member: member3, text: "I love pizza", messageId: UUID().uuidString)
        
        insertNewMessage(testMessage)
        insertNewMessage(testMessage2)
        insertNewMessage(testMessage3)

        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        styleChatRoom()
    }
    
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
    }
    
    // MARK: Styling
    
    private func styleChatRoom() {
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1)
        messageInputBar.sendButton.setTitleColor(UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1), for: .normal)
    }

    private func setUpNavigationBarItems() {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        let image = UIImage(named: "girl-5")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
}


extension MessageInstanceViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name) // variable member not being set!! ******************
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}


extension MessageInstanceViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}


extension MessageInstanceViewController: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
//        let message = messages[indexPath.section]
//        let color = message.member.color
//        avatarView.backgroundColor = color
    }
}


extension MessageInstanceViewController: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
        
//        let newMessage = Message(
//            key: UUID().uuidString,
//            user: (Auth.auth().currentUser)!,
//            content: text)
//
        
        let newMessage = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString)
        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}
