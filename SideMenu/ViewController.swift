//
//  ViewController.swift
//  SideMenu
//
//  Created by Rickey Hrabowskie on 10/23/16.
//  Copyright © 2016 Rickey Hrabowskie. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sideMenu = SideMenu(menuWidth: 150, menuItemTitles: ["Home", "User", "Settings"], parentViewController: self)
        sideMenu.menuDelegate = self
    }

    func didSelectMenuItem(withTitle title: String, index: Int) {
        print("Clicked on \(title) which has the index \(index)")
        if title == "Home" {
            print("user pressed home")
        } else if index == 1 {
            print("user pressed user")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

