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

class MessageCell: UITableViewCell {

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
    private func layerStyleInstall() {
//        self.contentView.
//        self.contentView.backgroundColor = UIColor.black
//        self.contentView.clipsToBounds = true
//        self.contentView.layer.cornerRadius = self.contentView.bounds.size.height/3.0
//        self.layer.cornerRadius = self.layer.bounds.size.height/3.0
//        self.contentView.clipsToBounds = true
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layerStyleInstall()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
