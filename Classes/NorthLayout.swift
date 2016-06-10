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
    typealias Size = CGSize
    typealias LayoutPriority = UILayoutPriority
    typealias LayoutAxis = UILayoutConstraintAxis
    extension View: LayoutPrioritizable {}

    public final class MinView: UIView, MinLayoutable {
        public init() {
            super.init(frame: .zero)
            setup()
        }
        public required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
        public override func intrinsicContentSize() -> CGSize {return .zero}
    }

#else
    import class AppKit.NSView
    typealias View = NSView
    typealias Size = NSSize
    typealias LayoutPriority = NSLayoutPriority
    typealias LayoutAxis = NSLayoutConstraintOrientation
    extension View: LayoutPrioritizable {
        func setContentCompressionResistancePriority(priority: LayoutPriority, forAxis axis: LayoutAxis) {
            setContentCompressionResistancePriority(priority, forOrientation: axis)
        }
        func setContentHuggingPriority(priority: LayoutPriority, forAxis axis: LayoutAxis) {
            setContentHuggingPriority(priority, forOrientation: axis)
        }
    }

    public final class MinView: NSView, MinLayoutable {
        public init() {
            super.init(frame: .zero)
            setup()
        }
        public required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
        public override var intrinsicContentSize: NSSize {return .zero}
    }
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
            guard view.enclosingScrollView == nil else {
                // fallback to the view.northLayoutFormat because UIScrollView.contentSize is measured by its layout but not by the layout guides of this view controller
                return view.northLayoutFormat(metrics, views, options: options)
            }

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


    extension View {
        var enclosingScrollView: UIScrollView? {
            guard let s = self as? UIScrollView else { return superview?.enclosingScrollView }
            return s
        }
    }
#endif


protocol LayoutPrioritizable {
    func setContentCompressionResistancePriority(priority: LayoutPriority, forAxis axis: LayoutAxis)
    func setContentHuggingPriority(priority: LayoutPriority, forAxis axis: LayoutAxis)
}


extension LayoutPriority {
    static var required: LayoutPriority = 1000
    static var high: LayoutPriority = 750
    static var fitInWindow: LayoutPriority = 500 - 1 // = NSLayoutPriorityWindowSizeStayPut - 1
    static var low: LayoutPriority = 250
    static var fittingSize: LayoutPriority = 50
}


// common setup for MinView
protocol MinLayoutable: LayoutPrioritizable {
    func setup()
}
extension MinLayoutable {
    func setup() {
        setContentCompressionResistancePriority(LayoutPriority.fittingSize, forAxis: .Horizontal)
        setContentCompressionResistancePriority(LayoutPriority.fittingSize, forAxis: .Vertical)
        setContentHuggingPriority(LayoutPriority.fitInWindow, forAxis: .Horizontal)
        setContentHuggingPriority(LayoutPriority.fitInWindow, forAxis: .Vertical)
    }
}
