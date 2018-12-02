//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
  private var model: ConversationModel

  init(model: ConversationModel) {
    self.model = model
    titleLabelStub = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      // workaround for displaying messages bottom -> top
      tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
  }
  @IBOutlet weak var inputTextField: UITextField!
  @IBOutlet weak var sendButton: UIButton!
  private var titleLabelStub: UILabel!
  var sendButtonLocked = false

  @IBAction func sendButtonPressed() {

    if sendButtonLocked {
      sendButton.shakeButton()
    } else {
      guard let text = inputTextField.text,
        let receiver = model.conversation.interlocutor?.userId, !text.isEmpty else { return }
      model.communicationService.communicator.sendMessage(text: text, to: receiver) { [weak self] success, error in
        if success {
          self?.inputTextField.text = nil
          if sendButtonLocked == false {
            self?.sendButtonLocked = true

            performAnimationSetButtonState(sendButton, enabled: false)
          }
        } else {
          let alert = UIAlertController(title: "Error occured",
                                        message: error?.localizedDescription,
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "done", style: .cancel))
          self?.present(alert, animated: true)
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    tableView.register(UINib(nibName: "IncomingMessageCell", bundle: nil),
                       forCellReuseIdentifier: "MessageIn")
    tableView.register(UINib(nibName: "OutgoingMessageCell", bundle: nil),
                       forCellReuseIdentifier: "MessageOut")

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 300

    navigationItem.titleView = titleLabelStub
    titleLabelStub.textColor = UIColor.black
    titleLabelStub.textAlignment = .center
    titleLabelStub.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    titleLabelStub.text = model.conversation.interlocutor?.name

    inputTextField.delegate = self
    inputTextField.autocorrectionType = UITextAutocorrectionType.no

    model.dataSourcer = MessagesDataSource(delegate: tableView,
                                           fetchRequest: model.frcService.messagesInConversation(with:
                                            model.conversation.conversationId!)!,
                                           context: model.frcService.saveContext)

    if let count = model.conversation.messages?.count, count > 0 {
      tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    // adding observers
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(inputModeDidChange),
                                           name: UIResponder.keyboardWillChangeFrameNotification,
                                           object: nil)

    model.setUserConnectionTracker(self)

    if model.conversation.isOnline == false {
      changeControlsState(enabled: false)
    } else {
      performAnimationSetLabelState(titleLabelStub, enabled: true)
    }

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    // removing observers
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    model.makeRead()

    view.gestureRecognizers?.removeAll()

  }

  // MARK: - Keyboard
  func isEmojiKeyboard() -> Bool {
    return textInputMode?.primaryLanguage == "emoji" || textInputMode?.primaryLanguage == nil
  }

  @objc func inputModeDidChange(sender: NSNotification) {

    if isEmojiKeyboard() {
      print("is emoji")
      view.frame.origin.y += 216.0
    }

  }

  @objc func keyboardWillShow(sender: NSNotification) {
    if view.frame.origin.y < 0.0 {
      view.frame.origin.y += 42.0
      return
    }

    if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      view.frame.origin.y -= keyboardSize.height
    }
  }

  @objc func keyboardWillHide(sender: NSNotification) {
    if isEmojiKeyboard() {
      view.frame.origin.y += 42.0
      return
    }

    if view.frame.origin.y >= 0.0 {
      return
    }

    if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      view.frame.origin.y += keyboardSize.height
    }
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }

  // MARK: - sendButtonLock
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == inputTextField {
            if let text = inputTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                if sendButtonLocked == true {
                    sendButtonLocked = false
                    performAnimationSetButtonState(sendButton, enabled: true)
                }
            } else {
                if sendButtonLocked == false {
                    sendButtonLocked = true

                    performAnimationSetButtonState(sendButton, enabled: false)
                }
            }
        }
    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  private func performAnimationSetButtonState(_ button: UIButton, enabled: Bool) {
    if enabled {
        // button state changed to "enabled"
        UIView.animate(withDuration: 1, animations: { () -> Void in
            button.backgroundColor = UIColor.green
        })

        UIView.animate(withDuration: 0.5,
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5) {
                            button.transform = CGAffineTransform.identity
                        }
        })

    } else {
        // button shutoff
        UIView.animate(withDuration: 1, animations: { () -> Void in
            button.backgroundColor = UIColor.red
        })

        UIView.animate(withDuration: 0.5,
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5) {
                            button.transform = CGAffineTransform.identity
                        }
        })
    }
  }

  private func performAnimationSetLabelState(_ label: UILabel, enabled: Bool) {
    if enabled {
        // interlocutor is online
        UIView.animate(withDuration: 1, animations: { () -> Void in
            label.textColor = UIColor.green
            label.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
        })
    } else {
        // interlocutor is offline
        UIView.animate(withDuration: 1, animations: { () -> Void in
            label.textColor = UIColor.black
            label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
  }
}
// MARK: - UITableViewDataSource , UITableViewDelegate
extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = model.dataSourcer?.fetchedResultsController.sections?.count else {
      return 0
    }

    return sections
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = model.dataSourcer?.fetchedResultsController.sections else {
      return 0
    }

    return sections[section].numberOfObjects
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var myCell: MessageCell?

    if let message = model.dataSourcer?.fetchedResultsController.object(at: indexPath) {

      var identifier: String

      if message.isIncoming {
        identifier = "MessageIn"
      } else {
        identifier = "MessageOut"
      }

      if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell {
        myCell = cell
      } else {
        myCell = MessageCell(style: .default, reuseIdentifier: identifier)
      }

      myCell?.messageText = message.messageText
      myCell?.isIncoming = message.isIncoming

      // workaround for displaying messages bottom -> top
      myCell?.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    return myCell ?? UITableViewCell()
  }

  // delete implementation
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      //remove from coredata here
      // ...
      //      sketch :
      //      let message = fetchedResultsController.object(at: indexPath)
      //      CoreDataService.shared.delete(message)
      //      CoreDataService.shared.save()

    }
  }

}

// MARK: - UITextFieldDelegate
extension ConversationViewController: UITextFieldDelegate {
  // hide the keyboard after pressing return key
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }

  // limiting input length for textfield
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.count + string.count - range.length
    return newLength <= 300
  }

}

extension ConversationViewController: IUserConnectionTracker {

    func changeControlsState(enabled: Bool) {
        if enabled {
            // set controls on
            DispatchQueue.main.async {
                self.textFieldDidChange(self.inputTextField)
                self.inputTextField.isEnabled = true

                self.performAnimationSetLabelState(self.titleLabelStub, enabled: true)
            }

        } else {
            // set controls off
            DispatchQueue.main.async {
                self.inputTextField.isEnabled = false
                self.performAnimationSetLabelState(self.titleLabelStub, enabled: false)

                if  self.sendButtonLocked == false {
                    self.sendButtonLocked = true
                    self.performAnimationSetButtonState(self.sendButton, enabled: false)
                }
            }
        }
    }

}
