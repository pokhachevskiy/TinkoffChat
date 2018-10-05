//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit


class MessageClass: NSObject {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessage: Bool
    
    init(pname: String, pmessage: String , pdate: Date, ponline: Bool, phasUnreadMessage: Bool)
    {
        self.name = pname
        self.message = pmessage
        self.date = pdate
        self.online = ponline
        self.hasUnreadMessage = phasUnreadMessage
        
    }
    
    // init without message
    init(pname: String,  pdate: Date, ponline: Bool, phasUnreadMessage: Bool)
    {
        self.name = pname
        self.date = pdate
        self.online = ponline
        self.hasUnreadMessage = phasUnreadMessage
        
    }
}



class ConversationsListViewController: UITableViewController {
    var arrayOfCellsWithMessagesOnline = [MessageClass]()
    var arrayOfCellsWithMessagesOffline = [MessageClass]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return arrayOfCellsWithMessagesOnline.count
        case 1:
            return arrayOfCellsWithMessagesOffline.count
        default:
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        var temporaryCell:MessageClass
        switch (indexPath.section) {
        case 0:
            temporaryCell = arrayOfCellsWithMessagesOnline[indexPath.row]
        case 1:
            temporaryCell = arrayOfCellsWithMessagesOffline[indexPath.row]
        default:
            temporaryCell = arrayOfCellsWithMessagesOnline[indexPath.row]
        }
        cell.name = temporaryCell.name
        cell.message = temporaryCell.message
        cell.date = temporaryCell.date
        cell.online = temporaryCell.online
        cell.hasUnreadMessage = temporaryCell.hasUnreadMessage
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
//        let temporaryCell = arrayOfCellsWithMessages[indexPath.row]
//    }
    
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
        
        arrayOfCellsWithMessagesOnline.append(MessageClass(pname: "Daniil Pokhachevskiy", pmessage: "got it.", pdate: Date(), ponline: true, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOnline.append(MessageClass(pname: "Alexey Piskunov", pmessage: "txt(debug:online,no unread)", pdate: Date(), ponline: true, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOnline.append(MessageClass(pname: "Filipp Firsov", pmessage: "txt(debug:online,has unread)", pdate: Date(), ponline: true, phasUnreadMessage: true))
        arrayOfCellsWithMessagesOnline.append(MessageClass(pname: "Vtorov Alexander Vladimirovich", pmessage: "quis nostrud exercitation ", pdate: Date(), ponline: true, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOnline.append(MessageClass(pname: "Lea Ratliff", pmessage: "in reprehenderit in voluptate ", pdate: Date(), ponline: true, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOnline.append(MessageClass(pname: "Yuriy",  pdate: Date(), ponline: true, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOnline.append(MessageClass(pname: "Vsevolod Pokhachevskiy", pdate: Date(), ponline: true, phasUnreadMessage: false))
        let someOldDate = Date(timeIntervalSinceReferenceDate: 542412351)
        arrayOfCellsWithMessagesOnline.append(MessageClass(pname: "Evgeniy Pelevin",  pmessage: "ut labore et dolore magna ", pdate: someOldDate, ponline: true, phasUnreadMessage: false))
        let anotherOldDate = Date(timeIntervalSinceReferenceDate: 542325951)
        
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Karina Zaynullina", pmessage: "i have seen it!", pdate: Date(), ponline: false, phasUnreadMessage: true))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Jay Rax", pmessage: "man it looks gorgeous", pdate: Date(), ponline: false, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Kim Mack Really long name thing", pmessage: "another offline msg", pdate: anotherOldDate, ponline: false, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "John Lee", pmessage:"txt(debug:offline,no unread)",  pdate: Date(), ponline: false, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Somebody with a long long long name", pmessage: "txt(debug:ofline,has unread)", pdate: Date(), ponline: false, phasUnreadMessage: true))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Jonas Walsh", pmessage: "delectus legendos est te, ne habeo", pdate: someOldDate, ponline: false, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Kieron Patterson", pmessage: "Quot tollit atomorum ea sed", pdate: Date(), ponline: false, phasUnreadMessage: false))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Abdul Barclay", pmessage: "et dico iracundia vix", pdate: Date(), ponline: false, phasUnreadMessage: true))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Kelan Morrison", pmessage: "Sale primis quo no", pdate: Date(), ponline: false, phasUnreadMessage: true))
        arrayOfCellsWithMessagesOffline.append(MessageClass(pname: "Rehaan Larson", pmessage: "eam cu persecuti intellegebat", pdate: Date(), ponline: false, phasUnreadMessage: false))
        
        
//        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
