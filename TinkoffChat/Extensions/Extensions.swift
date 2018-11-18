//
//  Extensions.swift
//  TinkoffChat
//
//  Created by Даниил on 21.09.2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//


import Foundation
import UIKit

extension UserDefaults {
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }

}


extension UIButton {
  
  func shakeButton() {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = 2
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 5, y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 5, y: self.center.y))
    self.layer.add(animation, forKey: "position")
  }
  
}



protocol IDataProviderDelegate: class {
  func beginUpdates()
  func endUpdates()
  
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}

extension UITableView: IDataSourceDelegate {
  // UITableView used as a IDataSourceDelegate protocol object
}



extension Message: MessageCellConfiguration {
  
  @nonobjc class func generateMessageId() -> String {
    return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
      .data(using: .utf8)!.base64EncodedString()
  }
  
}
