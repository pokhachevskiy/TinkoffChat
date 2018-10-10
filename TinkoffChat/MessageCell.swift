//
//  IncomingMessageCell.swift
//  TinkoffChat
//
//  Created by Даниил on 05/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class{
    var textMessage: String? {get set}
}

class MessageCell: UITableViewCell, MessageCellConfiguration {

    var textMessage: String? {
        didSet{
            if let strongTextMessage = textMessage {
                textMessageLabel?.text = strongTextMessage
            } else {
                textMessageLabel?.text = ""
            }
        }
    }
    
    @IBOutlet private var textMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
