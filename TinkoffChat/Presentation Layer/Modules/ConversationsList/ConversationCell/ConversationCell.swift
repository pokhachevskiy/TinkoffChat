//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

protocol IConversationCellConfiguration {
    var name: String? { get set }
    var lastMessageText: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class ConversationCell: UITableViewCell, IConversationCellConfiguration {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    var name: String? {
        didSet {
            nameLabel.text = name ?? "Name"
        }
    }

    var lastMessageText: String? {
        didSet {
            messageLabel.text = lastMessageText ?? "No messages yet."
            setMessageFont()
        }
    }

    var date: Date? {
        didSet {
            guard let date = date else {
                // stub in case we dont have date
                dateLabel.text = "Date"
                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Calendar.current.isDateInToday(date) ? "HH:mm" : "dd MMM"

            dateLabel.text = dateFormatter.string(from: date)
        }
    }

    var online = false {
        didSet {
            backgroundColor = online ? #colorLiteral(red: 1, green: 1, blue: 0.8980392157, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

    var hasUnreadMessages = false {
        didSet {
            setMessageFont()
        }
    }

    private func setMessageFont() {
        if lastMessageText == nil {
            messageLabel.font = .italicSystemFont(ofSize: 15)
        } else if hasUnreadMessages {
            messageLabel.font = .boldSystemFont(ofSize: 15)
        } else {
            messageLabel.font = .systemFont(ofSize: 15)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
