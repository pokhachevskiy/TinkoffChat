//
//  ConversationTableViewController.swift
//  TinkoffChat
//
//  Created by Даниил on 05/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var conversationTableView: UITableView! {
        didSet {
            // workaround for displaying messages bottom -> top
            conversationTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
    }

    private var fetchedResultsController: NSFetchedResultsController<Message>!
    private var frcManager = FRCManager()

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!

    var communicator: Communicator!
    var conversation: Conversation!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.conversationTableView.separatorStyle = .none
        self.conversationTableView.rowHeight = UITableView.automaticDimension
        self.conversationTableView.estimatedRowHeight = 44

        self.conversationTableView.dataSource = self
        self.conversationTableView.delegate = self
        self.textView.delegate = self

        let fetchRequest: NSFetchRequest<Message> = CoreDataService
            .sharedService
            .fetchRequest(.messagesByConversation,
                          dictionary: ["conversationId":
                            conversation.conversationId!])!
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        frcManager.delegate = conversationTableView
        fetchedResultsController = CoreDataService.sharedService.setupFRC(fetchRequest, frcManager: frcManager)
        CoreDataService.sharedService.fetchData(fetchedResultsController!)

        if let count = conversation.messages?.count, count > 0 {
            conversationTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }

        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = textView.frame.height/2
        let spacing = CGFloat(5)

        textView.textContainerInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        sendButton.layer.borderWidth = 1
        sendButton.layer.cornerRadius = sendButton.frame.height/2
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.sendButtonPressed(textView)
            return false
        }
        return true
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections?.count else {
            return 0
        }

        return sections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }

        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultsController.object(at: indexPath)
        var identifier = ""
        if message.isIncoming {
            identifier = "IncomingMessageCell"
        } else {
            identifier = "OutcomingMessageCell"
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageCell
            else {
            return MessageCell()
        }
        cell.textMessage = message.textMessage
        cell.isIncoming = message.isIncoming
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let text = textView.text, let receiver = conversation.receiver?.userId, !text.isEmpty else { return }

        communicator.sendMessage(string: text, to: receiver) { [weak self] success, _ in
            if success {
                self?.textView.text = ""

                let message: Message = CoreDataService.sharedService.add(.message)
                message.messageId = Message.generateMessageId()
                message.date = Date()
                message.conversation = self?.conversation
                message.isIncoming = false
                message.textMessage = text

                message.lastMessage = self?.conversation

                CoreDataService.sharedService.save()
            } else {
                let alertController = UIAlertController(title: "Error",
                                                        message: "message didn't send",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Done",
                                                        style: .destructive))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func loadData(with: ConversationCell) {
        self.title = with.name
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        conversation.hasUnreadMessage = false
        CoreDataService.sharedService.save()
        view.gestureRecognizers?.removeAll()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        if self.conversation.isOnline {
            self.turnControlsOn()
        } else {
            self.turnControlsOff()
        }
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y -= keyboardHeight
            print("keyboard height is:", keyboardHeight)
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // hides keyboard when tapped outside keyboard
        self.view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension ConversationViewController: LetControlsDelegate {
    func turnControlsOn() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = true
        }
    }

    func turnControlsOff() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = false
        }
    }
}
