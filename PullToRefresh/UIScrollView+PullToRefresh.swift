//
//  Created by Anastasiya Gorban on 4/14/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/PullToRefresh
//

import Foundation
import UIKit
import ObjectiveC

private var topPullToRefreshKey: UInt8 = 0
private var bottomPullToRefreshKey: UInt8 = 0

public extension UIScrollView {
    
    fileprivate(set) var topPullToRefresh: PullToRefresh? {
        get {
            return objc_getAssociatedObject(self, &topPullToRefreshKey) as? PullToRefresh
        }
        set {
            objc_setAssociatedObject(self, &topPullToRefreshKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate(set) var bottomPullToRefresh: PullToRefresh? {
        get {
            return objc_getAssociatedObject(self, &bottomPullToRefreshKey) as? PullToRefresh
        }
        set {
            objc_setAssociatedObject(self, &bottomPullToRefreshKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addPullToRefresh2(_ pullToRefresh: PullToRefresh, action: @escaping () -> ()) {
        pullToRefresh.scrollView = self
        pullToRefresh.action = action
        
        var originY: CGFloat
        let view = pullToRefresh.refreshView
        
        switch pullToRefresh.position {
        case .top:
            if let previousPullToRefresh = topPullToRefresh {
                removePullToRefresh(previousPullToRefresh)
            }
            
            topPullToRefresh = pullToRefresh
            originY = -view.frame.size.height
            
        case .bottom:
            if let previousPullToRefresh = bottomPullToRefresh{
                removePullToRefresh(previousPullToRefresh)
            }
            
            bottomPullToRefresh = pullToRefresh
            originY = contentSize.height
        }
        
        view.frame = CGRect(x: frame.width/2, y: originY, width: frame.width, height: view.frame.height)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        
        
        let background = UIView.init()
        background.frame = CGRect(x: frame.width/2, y: originY, width: frame.width, height: view.frame.height)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .white
        
        view.addSubview(background)
        view.sendSubview(toBack: background)
        
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[backgroundView(pullView)]",
            options: .alignAllBottom,
            metrics: nil,
            views: ["pullView": self, "backgroundView": background]))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[backgroundView(1000)]|",
            options: .alignAllBottom,
            metrics: nil,
            views: ["backgroundView": background, "view": view]))
        
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[view(pullView)]",
            options: .alignAllBottom,
            metrics: nil,
            views: ["pullView": self, "view": view]))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[view(60)]",
            options: .alignAllBottom,
            metrics: nil,
            views: ["view": view]))
    }
    
    public func addPullToRefresh(_ pullToRefresh: PullToRefresh, action: @escaping () -> ()) {
        pullToRefresh.scrollView = self
        pullToRefresh.action = action
        
        var originY: CGFloat
        let view = pullToRefresh.refreshView
        
        switch pullToRefresh.position {
        case .top:
            if let previousPullToRefresh = topPullToRefresh {
                removePullToRefresh(previousPullToRefresh)
            }
            
            topPullToRefresh = pullToRefresh
            originY = -view.frame.size.height
            
        case .bottom:
            if let previousPullToRefresh = bottomPullToRefresh{
                removePullToRefresh(previousPullToRefresh)
            }
            
            bottomPullToRefresh = pullToRefresh
            originY = contentSize.height
        }
        
        view.frame = CGRect(x: 0, y: originY, width: frame.width, height: view.frame.height)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        
        
        let background = UIView.init()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .white
        
        addSubview(background)
        sendSubview(toBack: background)
        
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[pullView]-(<=1)-[backgroundView(pullView)]",
            options: .alignAllBottom,
            metrics: nil,
            views: ["pullView": self, "backgroundView": background]))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[backgroundView(1000)]",
            options: .alignAllBottom,
            metrics: nil,
            views: ["backgroundView": background]))
        
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[pullView]-(<=1)-[view(pullView)]",
            options: .alignAllBottom,
            metrics: nil,
            views: ["pullView": self, "view": view]))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[view(60)]",
            options: .alignAllBottom,
            metrics: nil,
            views: ["view": view]))
    }
    
    func removePullToRefresh(_ pullToRefresh: PullToRefresh) {
        switch pullToRefresh.position {
        case .top:
            topPullToRefresh?.refreshView.removeFromSuperview()
            topPullToRefresh = nil
            
        case .bottom:
            bottomPullToRefresh?.refreshView.removeFromSuperview()
            bottomPullToRefresh = nil
        }
    }
    
    func startRefreshing(at position: Position) {
        switch position {
        case .top:
            topPullToRefresh?.startRefreshing()
            
        case .bottom:
            bottomPullToRefresh?.startRefreshing()
        }
    }
    
    func endRefreshing(at position: Position) {
        switch position {
        case .top:
            topPullToRefresh?.endRefreshing()
            
        case .bottom:
            bottomPullToRefresh?.endRefreshing()
        }
    }
}
