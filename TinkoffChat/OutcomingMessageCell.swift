//
//  OutcomingMessageCell.swift
//  TinkoffChat
//
//  Created by Даниил on 05/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

class OutcomingMessageCell: UITableViewCell {

    @IBOutlet weak var outcomingMessageTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
