//
//  TableViewController.swift
//  EdgeMenu
//
//  Created by Jakša Tomović on 04/12/2017.
//  Copyright © 2017 Jakša Tomović. All rights reserved.
//

import UIKit

class MenuController: UITableViewController, EdgeMenuDataSource {
 
    
    
    var iconNames = [String]()
    var menuNames = [String]()
    var edgeMenu: EdgeMenu?
    var cellTypeIdentifier = "cellLeft"
    var rightCellTypeIdentifier = "rightCellTypeIdentifier"
    
    fileprivate let textColorNormal = UIColor.white
    fileprivate let textColorHighlighted = UIColor(red: 0.46,
                                                   green: 0.82,
                                                   blue: 0.89,
                                                   alpha: 1)
    fileprivate let textColorSelected = UIColor(red: 0.07,
                                                green: 0.73,
                                                blue: 0.86,
                                                alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        tableView.scrollsToTop = false
        self.clearsSelectionOnViewWillAppear = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellTypeIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: rightCellTypeIdentifier)

        iconNames.append("imgBehance")
        iconNames.append("imgDribble")
        iconNames.append("imgFacebook")
        iconNames.append("imgLinkedIn")
        iconNames.append("imgTwitter")
        iconNames.append("imgGooglePlus")
        iconNames.append("imgVimeo")

        menuNames.append("Behance")
        menuNames.append("Dribbble")
        menuNames.append("Facebook")
        menuNames.append("LinkedIn")
        menuNames.append("Twitter")
        menuNames.append("GooglePlus")
        menuNames.append("Vimeo")
    }
    
    var shapeColor: UIColor? = UIColor(red: 0.07, green: 0.83, blue: 0.86, alpha: 1)
    var blurStyle = UIBlurEffectStyle.dark
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cellTypeIdentifier == "cellRight" {
            let cell = tableView.dequeueReusableCell(withIdentifier: rightCellTypeIdentifier, for: indexPath)
            cell.textLabel?.text = menuNames[indexPath.row]
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            cell.imageView?.image = UIImage(named: iconNames[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTypeIdentifier,
                                                     for: indexPath)
            cell.textLabel?.text = menuNames[indexPath.row]
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            cell.imageView?.image = UIImage(named: iconNames[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func unselectRowAtIndexPath(_ indexPath: IndexPath) {
        if indexPath == edgeMenu?.selectedIndexPath {
            getCellFor(indexPath).textLabel?.textColor = textColorSelected
        } else {
            getCellFor(indexPath).textLabel?.textColor = textColorNormal
        }
    }
    
    func preselectRowAtIndexPath(_ indexPath: IndexPath) {
        getCellFor(indexPath).textLabel?.textColor = textColorHighlighted
    }
    
    func setSelectedIndexPath(_ indexPath: IndexPath) {
        getCellFor(indexPath).textLabel?.textColor = textColorSelected
    }
    
  
    
    
    //Called when the user releases the gesture on a menu item
    func selectRowAtIndexPath(_ indexPath: IndexPath) {
        self.tableView(self.tableView, didSelectRowAt: indexPath)
    }
    
    // MARK: - Table view delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        CariocaMenu.Log("didSelectRowAtIndexPath \(indexPath.row)")
        //Transfer the event to the menu, so that he can manage the selection
//        cariocaMenu?.didSelectRowAtIndexPath(indexPath, fromContentController: true)
//    }
    
    // MARK: - Get the Cell
    fileprivate func getCellFor(_ indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.cellForRow(at: indexPath)! 
    }
    
    // MARK: - Data source protocol
    var menuView: UIView {
        return self.view
    }
    
    func heightByMenuItem() -> CGFloat {
        return self.tableView(self.tableView, heightForRowAt: IndexPath(item: 0, section: 0))
    }
    
    func numberOfMenuItems() -> Int {
        return self.tableView(self.tableView, numberOfRowsInSection: 0)
    }
    
    func iconForRowAtIndexPath(_ indexPath: IndexPath) -> UIImage {
        return UIImage(named: "\(iconNames[indexPath.row])_indicator.png")!
    }
    
    func setCellIdentifierForEdge(_ identifier: String) {
        cellTypeIdentifier = identifier
        self.tableView.reloadData()
    }
}
