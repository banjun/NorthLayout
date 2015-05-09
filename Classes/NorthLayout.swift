//
//  NorthLayout.swift
//  NorthLayout
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//


import UIKit


extension UIView {
    func autolayoutFormat(metrics: [String:CGFloat], _ views: [String:UIView]) -> String -> Void {
        return self.autolayoutFormat(metrics, views, options: nil)
    }
    
    func autolayoutFormat(metrics: [String:CGFloat], _ views: [String:UIView], options: NSLayoutFormatOptions) -> String -> Void {
        for v in views.values {
            if !v.isDescendantOfView(self) {
                v.setTranslatesAutoresizingMaskIntoConstraints(false)
                self.addSubview(v)
            }
        }
        return { (format: String) in
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views))
        }
    }
}
