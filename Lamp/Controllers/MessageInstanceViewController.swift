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

class MessageInstanceViewController: MessagesViewController {

    var profileRef: DatabaseReference!
    
    var userId: String = "JHanuudAYNg4hTvMbLS9poOdCrx1"
    
    // MARK: Firestore
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private let storage = Storage.storage().reference()
    
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    
    private let channelId: String = "FK3etvRW7SmKraOgQB6L"
    
    // clean up for listener
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reference = db.collection(["channels", channelId, "thread"].joined(separator: "/"))

        // calls snapshot listener whenever there is a change to the database
        messageListener = reference?.order(by: "created", descending: false).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        styleChatRoom()
    }
    
    // MARK: Helpers
    
    // saves text from messageInputBar to database
    private func save(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    // inserts new message to message collection
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        messages.append(message)
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
        
        let senderInitials = "S"
        let receiverInitials = "R"
        avatarView.initials = isFromCurrentSender(message: message) ? senderInitials : receiverInitials
    }
}

extension MessageInstanceViewController: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
        
        // 1
        let message = Message(userId: userId, content: text)
        
        // 2
        save(message)
        
        // 3
        inputBar.inputTextView.text = ""
    }
}
