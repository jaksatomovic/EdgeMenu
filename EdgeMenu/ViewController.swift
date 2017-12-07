//
//  ViewController.swift
//  EdgeMenu
//
//  Created by Jakša Tomović on 04/12/2017.
//  Copyright © 2017 Jakša Tomović. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EdgeMenuDelegate {
    func cariocaMenuDidSelect(_ menu: EdgeMenu, indexPath: IndexPath) {
        print("did select \(indexPath.row)")
    }
    var menu: EdgeMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialiseEdgeMenu()
    }
    
    private func initialiseEdgeMenu() {
        let dataSource = MenuController() as EdgeMenuDataSource
        menu = EdgeMenu(dataSource: dataSource, delegate: self, hostView: self.view)
    }
}
