//
//  ConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessage: Bool {get set}
}

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var textMessage: UILabel!

    var name: String? {
        didSet {
            if let strongName = name {
                nameLabel?.text = strongName
            } else {
                nameLabel?.text = "Unknown"
            }
        }
    }
    var message: String? {
        didSet {
            if let strongTextMessage = message {
                self.textMessage.text = strongTextMessage
            } else {
                self.textMessage.text = "No messages yet"
                self.textMessage.font = UIFont.italicSystemFont(ofSize: self.textMessage.font.pointSize)
            }
        }
    }
    var date: Date? {
        didSet {
            if let strongDate = date {
                let calendar = Calendar.current
                if calendar.isDateInToday(strongDate) {
                    // today case
                    let hhmmFormatter = DateFormatter()
                    hhmmFormatter.dateFormat = "HH:mm"
                    dateTime?.text = hhmmFormatter.string(from: strongDate)
                } else {
                    let ddmmFormatter = DateFormatter()
                    ddmmFormatter.dateFormat = "dd MMM"
                    dateTime?.text = ddmmFormatter.string(from: strongDate)
                }
                dateTime.isHidden = false
            }
        }
    }
    var online: Bool = false {
        didSet {
            if online {
                self.backgroundColor = UIColor(rgb: 0xffffe5)
            } else {
                self.backgroundColor = UIColor(named: "white")
            }
        }
    }
    var hasUnreadMessage: Bool = false {
        didSet {
            if message == nil {
                return
            }
            if hasUnreadMessage {
                self.textMessage.font = UIFont.boldSystemFont(ofSize: textMessage.font.pointSize)
            } else {
                self.textMessage.font = UIFont.systemFont(ofSize: textMessage.font.pointSize)
            }
        }
    }

    func configureForLabels (name: String?,
                             textLastMessage: String?,
                             dateLastMessage: Date?,
                             isOnline: Bool,
                             hasUnreadMessage: Bool) {
        self.name = name
        self.message = textLastMessage
        self.date = dateLastMessage
        self.online = isOnline
        self.hasUnreadMessage = hasUnreadMessage
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
