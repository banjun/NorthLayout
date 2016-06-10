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
    /// autolayout with enabling autolayout for subviews as side effects
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


#if os(iOS)
    extension UIViewController {
        /// autolayout by replacing vertical edges `|`...`|` to `topLayoutGuide` and `bottomLayoutGuide`
        public func northLayoutFormat(metrics: [String: CGFloat], _ views: [String: AnyObject], options: NSLayoutFormatOptions = []) -> (String) -> Void {
            var vs = views
            vs["topLayoutGuide"] = topLayoutGuide
            vs["bottomLayoutGuide"] = bottomLayoutGuide
            let autolayout = view.northLayoutFormat(metrics, vs, options: options)
            return { (format: String) in
                autolayout(!format.hasPrefix("V:") ? format : format
                    .stringByReplacingOccurrencesOfString("V:|", withString: "V:[topLayoutGuide]")
                    .stringByReplacingOccurrencesOfString("|", withString: "[bottomLayoutGuide]"))
            }
        }
    }
#endif
