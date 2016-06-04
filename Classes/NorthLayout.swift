//
//  NorthLayout.swift
//  NorthLayout
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias UXView = UIView
    #else
    import AppKit
    public typealias UXView = NSView
#endif


public extension UXView {
    public func northLayoutFormat(_ metrics: [String:CGFloat], _ views: [String:UXView]) -> (String) -> Void {
        return self.northLayoutFormat(metrics, views, options: [])
    }
    
    public func northLayoutFormat(_ metrics: [String:CGFloat], _ views: [String:UXView], options: NSLayoutFormatOptions) -> (String) -> Void {
        for v in views.values {
            #if os(iOS)
                let isAlreadySubview = v.isDescendant(of: self)
                #else
                let isAlreadySubview = v.isDescendantOf(self)
            #endif
            if !isAlreadySubview {
                v.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(v)
            }
        }
        return { (format: String) in
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views))
        }
    }
}
