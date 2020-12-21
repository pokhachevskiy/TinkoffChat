//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import CoreData
import UIKit

class ConversationsListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    private var model: IConversationListModel
    private let presentationAssembly: IPresentationAssembly

    init(model: IConversationListModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        model.restoreThemeSettings()
        setupTableView()

        model.dataSourcer = ConversationsDataSource(delegate: tableView,
                                                    fetchRequest: model.frcService.allConversations()!,
                                                    context: model.frcService.saveContext)
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        // adding observers
        setupNavigationBarItems()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ConversationCell", bundle: nil),
                           forCellReuseIdentifier: "ConversationCell")
    }

    private func setupNavigationBarItems() {
        navigationItem.title = "Tinkoff Chat"

        let profileButton = UIBarButtonItem(title: "Profile",
                                            style: .plain,
                                            target: self,
                                            action: #selector(profileButtonFunc))
        navigationItem.rightBarButtonItem = profileButton

        let themesButton = UIBarButtonItem(title: "Themes",
                                           style: .plain,
                                           target: self,
                                           action: #selector(themesButtonFunc))

        navigationItem.leftBarButtonItem = themesButton
    }

    @objc func profileButtonFunc() {
        let controller = presentationAssembly.profileViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [controller]

        present(navigationController, animated: true)
    }

    @objc func themesButtonFunc() {
        let controller = presentationAssembly
            .themesViewController { [weak self] (controller: ThemesViewController, selectedTheme: UIColor?) in
                guard let theme = selectedTheme else { return }
                controller.view.backgroundColor = theme
                self?.model.saveSettings(for: theme)
            }

        let navigationController = UINavigationController()
        navigationController.viewControllers = [controller]

        present(navigationController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversation = model.dataSourcer?.fetchedResultsController.object(at: indexPath) else { return }
        let controller = presentationAssembly.conversationViewController(
            model: ConversationModel(
                communicationService: model.communicationService,
                frcService: model.frcService,
                conversation: conversation
            ))

        controller.navigationItem.title = conversation.interlocutor?.name
        navigationController?.pushViewController(controller, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        guard let sectionsCount = model.dataSourcer?.fetchedResultsController.sections?.count else {
            return 0
        }

        return sectionsCount
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = model.dataSourcer?.fetchedResultsController.sections else {
            return 0
        }

        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ConversationCell"
        var myCell: ConversationCell

        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell {
            myCell = cell
        } else {
            myCell = ConversationCell(style: .default, reuseIdentifier: identifier)
        }

        if let conversation = model.dataSourcer?.fetchedResultsController.object(at: indexPath) {
            if let interlocutor = conversation.interlocutor {
                myCell.name = interlocutor.name
            }

            myCell.online = conversation.isOnline
            myCell.date = conversation.lastMessage?.date ?? nil
            myCell.lastMessageText = conversation.lastMessage?.messageText ?? nil
            myCell.hasUnreadMessages = conversation.hasUnreadMessages
        }

        return myCell
    }
}
