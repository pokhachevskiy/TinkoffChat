//
//  ConversationDelegate.swift
//  TinkoffChat
//
//  Created by Daniil on 11/11/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

protocol ConversationDelegate: class {

    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)

    func beginUpdates()
    func endUpdates()
}
