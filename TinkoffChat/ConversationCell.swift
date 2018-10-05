//
//  ConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var textMessage: UILabel!
    
    var name: String?{
        get{
            return nameLabel.text
        }
        set {
            if let strongName = newValue {
                nameLabel?.text = strongName
            }
        }
    }
    var message: String?{
        get {
            return textMessage.text
        }
        set {
            if let strongTextMessage = newValue {
                self.textMessage.text = strongTextMessage
            } else {
                self.textMessage.text = "No messages yet"
                print(UIFont.italicSystemFont(ofSize: 20))
                self.textMessage.font = UIFont.italicSystemFont(ofSize: 20)
            }
        }
    }
    var date: Date? {
        get {
            return Date()
        }
        set {
            if let strongDate = newValue {
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
            }
        }
    }
    var online: Bool{
        get{
            return self.backgroundColor == UIColor(rgb: 0xffffe5)
        }
        set{
            if newValue {
                self.backgroundColor = UIColor(rgb: 0xffffe5)
            } else {
                self.backgroundColor = UIColor(named: "white")
            }
        }
    }
    var hasUnreadMessage: Bool{
        get{
            return self.textMessage.font == UIFont.boldSystemFont(ofSize: textMessage.font.pointSize)
        }
        set{
            if newValue{
                self.textMessage.font = UIFont.boldSystemFont(ofSize: textMessage.font.pointSize)
            } else {
                self.textMessage.font = UIFont.systemFont(ofSize: textMessage.font.pointSize)
            }
        }
    }

    func configureForLabels (name: String?, textLastMessage: String?, dateLastMessage: Date?, isOnline: Bool, hasUnreadMessage: Bool){
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
