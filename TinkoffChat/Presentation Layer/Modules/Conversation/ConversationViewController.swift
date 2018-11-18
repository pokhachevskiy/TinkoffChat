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
  var sendButtonLocked = false
  
  
  @IBAction func sendButtonPressed() {
    
    if (sendButtonLocked)
    {
      sendButton.shakeButton()
    }
    else {
      guard let text = inputTextField.text,
        let receiver = model.conversation.interlocutor?.userId, !text.isEmpty else { return }
      model.communicationService.communicator.sendMessage(text: text, to: receiver) { [weak self] success, error in
        if success {
          self?.inputTextField.text = nil
          self?.sendButtonLocked = true
        } else {
          let alert = UIAlertController(title: "Error occured", message: error?.localizedDescription, preferredStyle: .alert)
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
    
    inputTextField.delegate = self
    inputTextField.autocorrectionType = UITextAutocorrectionType.no
    
    model.dataSourcer = MessagesDataSource(delegate: tableView, fetchRequest: model.frcService.messagesInConversation(with: model.conversation.conversationId!)!, context: model.frcService.saveContext)
    
    if let count = model.conversation.messages?.count, count > 0 {
      tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    // adding observers
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(inputModeDidChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    if  model.conversation.isOnline {
      self.turnControlsOn()
    } else {
      self.turnControlsOff()
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
    
    if isEmojiKeyboard(){
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
    if isEmojiKeyboard(){
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
        sendButtonLocked = false
      } else {
        sendButtonLocked = true
      }
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
      
      if (message.isIncoming){
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
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    return true;
  }
  
  
  // limiting input length for textfield
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.count + string.count - range.length
    return newLength <= 300
  }
  
}



// MARK: - ConversationViewControllerExtension
extension ConversationViewController {
  
  func turnControlsOn() {
    DispatchQueue.main.async {
      self.textFieldDidChange(self.inputTextField)
      self.inputTextField.isEnabled = true
      self.sendButtonLocked = false
    }
  }
  
  func turnControlsOff() {
    DispatchQueue.main.async {
      self.sendButtonLocked = true
      self.inputTextField.isEnabled = false
    }
  }
  
}
