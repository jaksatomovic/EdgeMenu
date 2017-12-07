//
//  EdgeMenu.swift
//  EdgeMenu
//
//  Created by Jakša Tomović on 04/12/2017.
//  Copyright © 2017 Jakša Tomović. All rights reserved.
//

import UIKit

public class EdgeMenu: NSObject, UIGestureRecognizerDelegate {

    
    public init(dataSource: EdgeMenuDataSource,
                delegate: EdgeMenuDelegate,
                hostView: UIView) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.hostView = hostView
        self.containerView = UIView()
        self.menuHeight = dataSource.heightByMenuItem() * CGFloat(dataSource.numberOfMenuItems())
        super.init()
        addInView()
    }
    private var containerView: UIView
    var hostView: UIView
    var menuView: UIView {
        return dataSource.menuView
    }
    private var menuTopEdgeConstraint: NSLayoutConstraint?
    private var menuOriginalY: CGFloat = 0.0
    private var panOriginalY: CGFloat = 0.0
    private var sidePanLeft = UIScreenEdgePanGestureRecognizer()
    private var sidePanRight = UIScreenEdgePanGestureRecognizer()
    private var panGestureRecognizer = UIPanGestureRecognizer()
    var dataSource: EdgeMenuDataSource
    open var delegate: EdgeMenuDelegate?
    open var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var preSelectedIndexPath: IndexPath!
    open var openingEdge: MenuEdge = .left
    private let menuHeight: CGFloat
    
    private func addInView() {
        containerView.isHidden = true
        addBlur()
        containerView.backgroundColor = UIColor.clear
        hostView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.fillSuperview()
        containerView.setNeedsLayout()
        containerView.addSubview(menuView)
        sidePanLeft.addTarget(self, action: #selector(EdgeMenu.gestureTouched(_:)))
        hostView.addGestureRecognizer(sidePanLeft)
        sidePanLeft.edges = .left
        sidePanRight.addTarget(self, action: #selector(EdgeMenu.gestureTouched(_:)))
        hostView.addGestureRecognizer(sidePanRight)
        sidePanRight.edges = .right
        panGestureRecognizer.addTarget(self, action: #selector(EdgeMenu.gestureTouched(_:)))
        containerView.addGestureRecognizer(panGestureRecognizer)
        
        //Autolayout constraints for the menu
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.addConstraint(NSLayoutConstraint(item: menuView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: menuHeight))
        let topEdgeConstraint = EdgeMenu.getEqualConstraint(menuView, toItem: containerView, attribute: .top)
        containerView.addConstraints([
            EdgeMenu.getEqualConstraint(menuView, toItem: containerView, attribute: .width),
            EdgeMenu.getEqualConstraint(menuView, toItem: containerView, attribute: .leading),
            topEdgeConstraint
            ])
        menuTopEdgeConstraint = topEdgeConstraint
        menuView.setNeedsLayout()
    }
    
    private func addBlur() {
        if NSClassFromString("UIVisualEffectView") != nil {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                as UIVisualEffectView
            visualEffectView.frame = containerView.bounds
            visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            containerView.addSubview(visualEffectView)
        } else {
            let visualEffectView = UIView(frame: containerView.bounds)
            visualEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            containerView.addSubview(visualEffectView)
        }
    }
    
    open func didSelectRowAtIndexPath(_ indexPath: IndexPath, fromContentController: Bool) {
        if preSelectedIndexPath != nil {
            dataSource.unselectRowAtIndexPath(preSelectedIndexPath)
            preSelectedIndexPath = nil
        }
        let indexPathForDeselection = selectedIndexPath
        selectedIndexPath = indexPath
        if !fromContentController {
            dataSource.selectRowAtIndexPath(indexPath)
        } else {
            dataSource.unselectRowAtIndexPath(indexPathForDeselection)
            dataSource.setSelectedIndexPath(indexPath)
        }
        delegate?.cariocaMenuDidSelect(self, indexPath: indexPath)
        if fromContentController {
            hideMenu()
        }
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func gestureTouched(_ gesture: UIGestureRecognizer) {
  
        let location = gesture.location(in: gesture.view)
        if gesture.state == .began {
            if gesture != panGestureRecognizer {
                let newEdge: MenuEdge = (gesture == sidePanLeft) ? .left : .right
                if openingEdge != newEdge {
                    openingEdge = newEdge
                    dataSource.setCellIdentifierForEdge((openingEdge == .left) ? "cellRight" : "cellLeft")
                }
            }
//            delegate?.cariocaMenuWillOpen(self)
            showMenu()
            
            panOriginalY = location.y
            
            menuOriginalY = panOriginalY
                - ((dataSource.heightByMenuItem() * CGFloat(selectedIndexPath.row))
                    + (dataSource.heightByMenuItem()/2))
            
            menuTopEdgeConstraint?.constant = menuOriginalY
//            delegate?.cariocaMenuDidOpen(self)
        }
        if gesture.state == .changed {
     
            let difference = panOriginalY - location.y
            let newYconstant = menuOriginalY + difference

            
            menuTopEdgeConstraint?.constant = newYconstant
            
            var matchingIndex = Int(floor((location.y - newYconstant) / dataSource.heightByMenuItem()))
            matchingIndex = (matchingIndex < 0) ?
                0 : ((matchingIndex > (dataSource.numberOfMenuItems()-1)) ?
                    (dataSource.numberOfMenuItems()-1) : matchingIndex)
            
            let calculatedIndexPath = IndexPath(row: matchingIndex, section: 0)
            
            if preSelectedIndexPath !=  calculatedIndexPath {
                if preSelectedIndexPath != nil {
                    dataSource.unselectRowAtIndexPath(preSelectedIndexPath)
                }
                preSelectedIndexPath = calculatedIndexPath
                dataSource.preselectRowAtIndexPath(preSelectedIndexPath)
            }
            
            
        }
        if gesture.state == .ended {
            menuOriginalY = location.y
            let indexPathForDeselection = selectedIndexPath
            selectedIndexPath = preSelectedIndexPath
            dataSource.unselectRowAtIndexPath(indexPathForDeselection)
            didSelectRowAtIndexPath(selectedIndexPath, fromContentController: true)
        }
        
        if gesture.state == .failed { print("Failed : \(gesture)") }
        if gesture.state == .possible { print("Possible : \(gesture)") }
        if gesture.state == .cancelled { print("cancelled : \(gesture)") }
    }

    open func showMenu() {
        containerView.isHidden = false
        containerView.alpha = 1
        hostView.layoutIfNeeded()
    }
    
    open func hideMenu() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.containerView.alpha = 0
        }, completion: { _ -> Void in
            self.containerView.isHidden = true
        })
    }
}

extension EdgeMenu {
    class func getEqualConstraint(_ item: AnyObject,
                                  toItem: AnyObject,
                                  attribute: NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item,
                                  attribute: attribute,
                                  relatedBy: .equal,
                                  toItem: toItem,
                                  attribute: attribute,
                                  multiplier: 1,
                                  constant: 0)
    }
}
