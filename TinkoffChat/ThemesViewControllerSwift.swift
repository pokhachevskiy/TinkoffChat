//
//  ThemesViewControllerSwift.swift
//  TinkoffChat
//
//  Created by Даниил on 13/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {

    typealias GetTheme = (ThemesStructureSwift.Theme) -> ()
    
    var closure: GetTheme?
    
    var themes = ThemesStructureSwift(theme1: ThemesStructureSwift.Theme.init(navigationBarColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), theme2: ThemesStructureSwift.Theme.init(navigationBarColor: #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)), theme3: ThemesStructureSwift.Theme.init(navigationBarColor: #colorLiteral(red: 0.7725490196, green: 0.7019607843, blue: 0.3450980392, alpha: 1)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = UserDefaults.standard.colorForKey(key: "Theme") {
            view.backgroundColor = color
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func themeButtonPressed(_ sender: UIButton) {
        if let buttonTitle = sender.titleLabel?.text {
            
            switch buttonTitle {
            case "Светлая":
                let theme = themes.theme1
                view.backgroundColor = theme.navigationBarColor
                closure?(theme)
            case "Темная":
                let theme = themes.theme2
                view.backgroundColor = theme.navigationBarColor
                closure?(theme)
            case "Шампань":
                let theme = themes.theme3
                view.backgroundColor = theme.navigationBarColor
                closure?(theme)
            default:
                print(#function, ": Smth went wrong, theme not exists")
            }
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
