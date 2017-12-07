//
//  EdgeMenu+Protocols+Enums.swift
//  EdgeMenu
//
//  Created by Jakša Tomović on 04/12/2017.
//  Copyright © 2017 Jakša Tomović. All rights reserved.
//

import Foundation
import UIKit

@objc public enum MenuEdge: Int {
    case left = 0
    case right = 1
}


@objc public protocol EdgeMenuDelegate {
//    func edgeMenuWillOpen(_ menu: EdgeMenu)
//    func cariocaMenuDidOpen(_ menu: EdgeMenu)
//    func cariocaMenuWillClose(_ menu: EdgeMenu)
//    func cariocaMenuDidClose(_ menu: EdgeMenu)
    func cariocaMenuDidSelect(_ menu: EdgeMenu, indexPath: IndexPath)
}

@objc public protocol EdgeMenuDataSource {
    var menuView: UIView { get }
    var shapeColor: UIColor? { get set }
    var blurStyle: UIBlurEffectStyle { get set }
    func unselectRowAtIndexPath(_ indexPath: IndexPath)
    func preselectRowAtIndexPath(_ indexPath: IndexPath)
    func selectRowAtIndexPath(_ indexPath: IndexPath)
    func heightByMenuItem() -> CGFloat
    func numberOfMenuItems() -> Int
    func iconForRowAtIndexPath(_ indexPath: IndexPath) -> UIImage
    func setSelectedIndexPath(_ indexPath: IndexPath)
    func setCellIdentifierForEdge(_ identifier: String)
}
