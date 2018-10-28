//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

class MessageClass {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessage: Bool
    
    
    init(name: String, message: String , date: Date, online: Bool, hasUnreadMessage: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessage = hasUnreadMessage
    }
    
    // init without message
    init(name: String, date: Date, online: Bool, hasUnreadMessage: Bool) {
        self.name = name
        self.date = date
        self.online = online
        self.hasUnreadMessage = hasUnreadMessage
    }
}



class ConversationsListViewController: UITableViewController {
    
    private var communicator: Communicator = MultipeerCommunicator()
    private var communicationManager = CommunicationManager()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communicationManager.conversations[status[section]!]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        
        let receivedConversation = communicationManager.conversations[status[indexPath.section]!]![indexPath.row]
        cell.name = receivedConversation.name
        cell.message = receivedConversation.message
        cell.date = receivedConversation.date
        cell.online = receivedConversation.online
        cell.hasUnreadMessage = receivedConversation.hasUnreadMessage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return "Error"
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communicator.delegate = communicationManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("ConversationsListReloadData"), object: nil)
        tableView.reloadData()
    }
    
    @objc private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // removing observers
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ConversationsListReloadData"), object: nil)
    }
    
    func logThemeChanging (selectedTheme: UIColor){
        print(#function, selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme
        DispatchQueue.global(qos: .userInitiated).async {
            UserDefaults.standard.setColor(color: selectedTheme, forKey: "Theme")
        }
    }
    
    func logThemeChangingSwift (selectedTheme: ThemesStructureSwift.Theme){
        print(#function, selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme.navigationBarColor
        DispatchQueue.global(qos: .userInitiated).async {
            UserDefaults.standard.setColor(color: selectedTheme.navigationBarColor, forKey: "Theme")
        }
    }
    

    let status = [0 : "online", 1 : "offline"]
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "toConversation":
            if let cell = sender as? ConversationCell,
                let conversationViewController = segue.destination as? ConversationViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    conversationViewController.loadData(with: cell)
                    conversationViewController.communicator = communicator
                    conversationViewController.conversation = communicationManager.conversations[status[indexPath.section]!]?[indexPath.row]
                }
            }
        case "toThemes":
            let navigationViewController = segue.destination as! UINavigationController
            
            if let themesViewController = navigationViewController.topViewController as? ThemesViewController {
                themesViewController.delegate = self
            } else if let themesViewControllerSwift = navigationViewController.topViewController as? ThemesViewControllerSwift {
                themesViewControllerSwift.closure = { logThemeChangingSwift }()
            }
        default:
            return
        }
    }
 

}

extension ConversationsListViewController : ​ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        self.logThemeChanging(selectedTheme: selectedTheme)
    }
    
    
}
