//
//  NorthLayout.swift
//  NorthLayout
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//

#if os(iOS)
    import class UIKit.UIView
    typealias View = UIView
#else
    import class AppKit.NSView
    typealias View = NSView
#endif


extension View {
    public func northLayoutFormat(metrics: [String: CGFloat], _ views: [String: AnyObject], options: NSLayoutFormatOptions = []) -> (String) -> Void {
        for case let v as View in views.values {
            #if os(iOS)
                let isAlreadySubview = v.isDescendantOfView(self)
            #else
                let isAlreadySubview = v.isDescendantOf(self)
            #endif
            if !isAlreadySubview {
                v.translatesAutoresizingMaskIntoConstraints = false
                addSubview(v)
            }
        }
        return { (format: String) in
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views))
        }
    }
}
