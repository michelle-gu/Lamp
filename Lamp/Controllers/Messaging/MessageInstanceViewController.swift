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
import FirebaseFirestore

// Message protocol to send information back to Message List View Contoller
protocol MessageSentDelegate {
    func updateChannelInfo(lastMessage: Message, channelId: String)
}

class MessageInstanceViewController: MessagesViewController {
    
    // specific delegate for message
    var messageDelegate: MessageSentDelegate!
    
    var userId: String = ""
    var userProfileURL = URL(string: "")
    
    // MARK: Firebase
    var ref: DatabaseReference!

    // MARK: Firestore
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private let storage = Storage.storage().reference()
    
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    
    var channelId: String = ""
    var matchId = ""
    
    // clean up for listener
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = Auth.auth().currentUser!.uid

        // reference to firestore message db
        reference = db.collection(["channels", channelId, "thread"].joined(separator: "/"))

        // calls snapshot listener whenever there is a change to the database
        messageListener = reference?.order(by: "created", descending: false).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            // loops through each message snapshot in thread list
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        
        messagesCollectionView.scrollToBottom() // TODO: messages do not scroll to bottom
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        styleChatRoom()
        setUpNavigationBarItems()
    }
    
    // MARK: Helpers
    
    // saves text from messageInputBar to database
    private func save(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            // if new message gets sent, update channel details by passing data through delegate
            let lastMessage = self.messages[self.messages.endIndex - 1]
            self.messageDelegate.updateChannelInfo(lastMessage: lastMessage, channelId: self.channelId)
            self.messagesCollectionView.scrollToBottom() // this works
        }
    }
    
    // inserts new message to message collection
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        messages.append(message)
        // message passed through the delegate to Message List VC
        messagesCollectionView.reloadData()
    }
    
    // observes new database changes
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }
        insertNewMessage(message)
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
        
        ref = Database.database().reference(withPath: "messaging")
        let members = ref.child("members").child(channelId)
        
        // goes through members of channel
        members.queryOrderedByKey().observe(.value, with: { (snapshot) in
            let membersDict = snapshot.value as? [String : NSObject] ?? [:]
            
            // loop through all members (two) ids to dict
            var matchUserId = "nil"
            for (key, _) in membersDict {
                if key != self.userId {
                    matchUserId = key
                }
            }
            
            let profileRef = Database.database().reference().child("user-profiles")
            let matchProfile = profileRef.child(matchUserId).child("profile")
            
            matchProfile.observe(.value, with: { (snapshot) in
                let matchDict = snapshot.value as? [String : AnyObject] ?? [:]
    
                if let matchName = matchDict["firstName"] as? String {
                    self.navigationItem.title = matchName
                }
            })
        })
    }
}

extension MessageInstanceViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: userId, displayName: "")
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
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {

        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {

        return CGSize(width: 0, height: 8)
    }

    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}


extension MessageInstanceViewController: MessagesDisplayDelegate {
    // bubble background colors
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let senderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1)
        let receiverColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        return isFromCurrentSender(message: message) ? senderColor : receiverColor
    }
    
    // bubble headers display
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    // bubble tail style
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        ref = Database.database().reference(withPath: "messaging")
        let members = ref.child("members").child(channelId)
        
        // goes through members of channel
        members.queryOrderedByKey().observe(.value, with: { (snapshot) in
            let membersDict = snapshot.value as? [String : NSObject] ?? [:]
            
            // loop through all members (two) ids to dict
            var matchUserId = "nil"
            for (key, _) in membersDict {
                if key != self.userId {
                    matchUserId = key
                }
            }
            
            let profileRef = Database.database().reference().child("user-profiles")
            
            profileRef.observe(.value, with: { (snapshot) in
                let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
                
                var userPicURL = URL(string: "blank-profile-pic")
                var matchPicURL = URL(string: "blank-profile-pic")
                
                let userData = profileDict[self.userId] as? [String : AnyObject] ?? [:]
                let userProfile = userData["profile"] as? [String : AnyObject] ?? [:]
                if let userPicVal = userProfile["profilePicture"] as? String {
                    if userPicVal != "" {
                        userPicURL = URL(string: userPicVal)
                    }
                }
                
                let matchData = profileDict[matchUserId] as? [String : AnyObject] ?? [:]
                let matchProfile = matchData["profile"] as? [String : AnyObject] ?? [:]
                if let matchPicVal = matchProfile["profilePicture"] as? String {
                    if matchPicVal != "" {
                        matchPicURL = URL(string: matchPicVal)
                    }
                }
                
                if self.isFromCurrentSender(message: message) {
                    avatarView.kf.setImage(with: userPicURL)
                } else {
                    avatarView.kf.setImage(with: matchPicURL)
                }
            })
        })
    }
}

extension MessageInstanceViewController: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
        
        // creates message form input bar and saves to db
        let message = Message(userId: userId, content: text)
        save(message)
        
        // clears message input bar
        inputBar.inputTextView.text = ""
    }
}
