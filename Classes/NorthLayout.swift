//
//  NorthLayout.swift
//  NorthLayout
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//


public protocol NorthLayoutableView: class {
    func isDescendant(of: Self) -> Bool
    var translatesAutoresizingMaskIntoConstraints: Bool { get set }
    func addSubview(_ subview: Self)
    func addConstraints(_ constraints: [NSLayoutConstraint])
}

public extension NorthLayoutableView {
    public func northLayoutFormat(_ metrics: [String: CGFloat], _ views: [String: Self], options: NSLayoutFormatOptions = []) -> (String) -> Void {
        for v in views.values {
            if !v.isDescendant(of: self) {
                v.translatesAutoresizingMaskIntoConstraints = false
                addSubview(v)
            }
        }
        return { (format: String) in
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views))
        }
    }
}

#if os(iOS)
    import class UIKit.UIView
    extension UIView: NorthLayoutableView {}
#else
    import class AppKit.NSView
    extension NSView: NorthLayoutableView {}
#endif
