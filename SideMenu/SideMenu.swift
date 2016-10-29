//
//  SideMenu.swift
//  SideMenu
//
//  Created by Rickey Hrabowskie on 10/23/16.
//  Copyright © 2016 Rickey Hrabowskie. All rights reserved.
//

import UIKit

protocol SideMenuDelegate {
    func didSelectMenuItem (withTitle title:String, index:Int)
}

class SideMenu: UIView, UITableViewDelegate, UITableViewDataSource {

    var backgroundView:UIView!
    var menuTable:UITableView!
    var animator:UIDynamicAnimator!
    
    var menuWidth:CGFloat = 0
    
    var menuItemTitles = [String]()
    
    var parentViewController = UIViewController()
    
    var menuDelegate:SideMenuDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(menuWidth:CGFloat, menuItemTitles:[String], parentViewController:UIViewController) {
        super.init(frame: CGRect(x: -menuWidth, y: 20, width: menuWidth, height: parentViewController.view.frame.height - 20))
        
        self.menuWidth = menuWidth
        self.menuItemTitles = menuItemTitles
        self.parentViewController = parentViewController
        
        self.backgroundColor = UIColor.darkGray
        parentViewController.view.addSubview(self)
        
        setupMenuView()
        
        animator = UIDynamicAnimator(referenceView: parentViewController.view)
        
        let showMenuRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideMenu.handleGestures(recognizer:)))
        
        showMenuRecognizer.direction = .right
        parentViewController.view.addGestureRecognizer(showMenuRecognizer)
        
        let hideMenuRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideMenu.handleGestures(recognizer:)))
        
        hideMenuRecognizer.direction = .left
        parentViewController.view.addGestureRecognizer(hideMenuRecognizer)
    }
    
    func handleGestures (recognizer:UISwipeGestureRecognizer) {
        if recognizer.direction == .right {
            toggleMenu(open: true)
        } else {
            toggleMenu(open: false)
        }
    }
    
    func toggleMenu (open:Bool) {
        animator.removeAllBehaviors()
        
        let gravityX:CGFloat = open ? 2 : -1
        let pushMagnitude:CGFloat = open ? 2 : -20
        let boundaryX:CGFloat = open ? menuWidth : -menuWidth - 5
        
        let gravity = UIGravityBehavior(items: [self])
        gravity.gravityDirection = CGVector(dx: gravityX, dy: 0)
        animator.addBehavior(gravity)
        
        let collision = UICollisionBehavior(items: [self])
        collision.addBoundary(withIdentifier: 1 as NSCopying, from: CGPoint(x: boundaryX, y: 20), to: CGPoint(x: boundaryX, y: parentViewController.view.bounds.height))
        animator.addBehavior(collision)
        
        let push = UIPushBehavior(items: [self], mode: .instantaneous)
        push.magnitude = pushMagnitude
        animator.addBehavior(push)
        
        let menuBehaviour = UIDynamicItemBehavior(items: [self])
        menuBehaviour.elasticity = 0.4
        animator.addBehavior(menuBehaviour)
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = open ? 0.5 : 0
        }
    }
    
    func setupMenuView() {
        backgroundView = UIView(frame: parentViewController.view.bounds)
        backgroundView.backgroundColor = UIColor.lightGray
        backgroundView.alpha = 0
        parentViewController.view.insertSubview(backgroundView, belowSubview: self)
        
        menuTable = UITableView(frame: self.bounds, style: .plain)
        menuTable.backgroundColor = UIColor.clear
        menuTable.separatorStyle = .none
        menuTable.isScrollEnabled = false
        menuTable.alpha = 1
        
        menuTable.delegate = self
        menuTable.dataSource = self
        
        menuTable.reloadData()
        
        self.addSubview(menuTable)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = menuItemTitles[indexPath.row]
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.textLabel?.font = UIFont(name: "AvenirNext", size: 13)
        cell?.textLabel?.textAlignment = .center
        
        cell?.backgroundColor = UIColor.clear
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        
        if let delegate = menuDelegate {
            delegate.didSelectMenuItem(withTitle: menuItemTitles[indexPath.row], index: indexPath.row)
        }
    }

}
