//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UITableViewController {
    private var communicator: Communicator = MultipeerCommunicator()
    private var communicationManager = CommunicationManager()
    private var frcManager = FRCManager()
    private var fetchedResultsController: NSFetchedResultsController<Conversation>!
    private var controlsDelegate: LetControlsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        communicator.delegate = communicationManager

        let fetchRequest: NSFetchRequest<Conversation> = CoreDataService.sharedService.getAll(.conversation)

        let onlineSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: false)
        let dateSortDescriptor = NSSortDescriptor(key: "lastMessage.date", ascending: false)
        let nameSortDescriptor = NSSortDescriptor(key: "receiver.name", ascending: true)

        fetchRequest.sortDescriptors = [onlineSortDescriptor, dateSortDescriptor, nameSortDescriptor]

        frcManager.delegate = self.tableView

        fetchedResultsController = CoreDataService.sharedService.setupFRC(fetchRequest, frcManager: frcManager)
        CoreDataService.sharedService.fetchData(fetchedResultsController)

        fetchedResultsController?.fetchedObjects?.forEach({ $0.isOnline = false })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }

        return sections[section].numberOfObjects
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchedResultsController?.sections?.count else {
            return 0
        }

        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell",
                                                 for: indexPath) as? ConversationCell
            else {
                return ConversationCell()
        }

        if let retrievedConversation = fetchedResultsController?.object(at: indexPath) {
            if let receiver = retrievedConversation.receiver {
                cell.name = receiver.name
            }

            cell.online = retrievedConversation.isOnline
            cell.date = retrievedConversation.lastMessage?.date ?? nil
            cell.message = retrievedConversation.lastMessage?.textMessage ?? nil
            cell.hasUnreadMessage = retrievedConversation.hasUnreadMessage

            if retrievedConversation.isOnline && retrievedConversation == controlsDelegate?.conversation {
                controlsDelegate?.turnControlsOn()
            } else {
                controlsDelegate?.turnControlsOff()
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return "Error"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    func logThemeChanging (selectedTheme: UIColor) {
        print(#function, selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme
        DispatchQueue.global(qos: .userInitiated).async {
            UserDefaults.standard.setColor(color: selectedTheme, forKey: "Theme")
        }
    }
    func logThemeChangingSwift (selectedTheme: ThemesStructureSwift.Theme) {
        print(#function, selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme.navigationBarColor
        DispatchQueue.global(qos: .userInitiated).async {
            UserDefaults.standard.setColor(color: selectedTheme.navigationBarColor, forKey: "Theme")
        }
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case "toConversation":
            if let cell = sender as? ConversationCell,
                let conversationViewController = segue.destination as? ConversationViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    controlsDelegate = conversationViewController
                    controlsDelegate?.conversation = fetchedResultsController?.object(at: indexPath)
                    conversationViewController.loadData(with: cell)
                    conversationViewController.communicator = communicator
                }
            }
        case "toThemes":
            let navigationViewController = segue.destination as? UINavigationController

            if let themesViewController = navigationViewController?.topViewController as? ThemesViewController {
                themesViewController.delegate = self
            } else if let themesViewControllerSwift = navigationViewController?.topViewController as?
                ThemesViewControllerSwift {
                themesViewControllerSwift.closure = { logThemeChangingSwift }()
            }
        default:
            return
        }
    }

}

extension ConversationsListViewController: ​ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        self.logThemeChanging(selectedTheme: selectedTheme)
    }
}

extension UITableView: ConversationDelegate {
    // this stub fixes line: "frcManager.delegate = self"
}
