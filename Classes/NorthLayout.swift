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
    public typealias FormatOptions = NSLayoutFormatOptions
    extension View: LayoutPrioritizable {}

    public final class MinView: UIView, MinLayoutable {
        public init() {
            super.init(frame: .zero)
            setup()
        }
        public required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
        public override var intrinsicContentSize : CGSize {return .zero}
    }

#else
    import class AppKit.NSView
    typealias View = NSView
    typealias Size = NSSize
    typealias LayoutPriority = NSLayoutConstraint.Priority
    typealias LayoutAxis = NSLayoutConstraint.Orientation
    public typealias FormatOptions = NSLayoutConstraint.FormatOptions
    extension View: LayoutPrioritizable {
        func setContentCompressionResistancePriority(_ priority: LayoutPriority, forAxis axis: LayoutAxis) {
            setContentCompressionResistancePriority(priority, for: axis)
        }
        func setContentHuggingPriority(_ priority: LayoutPriority, forAxis axis: LayoutAxis) {
            setContentHuggingPriority(priority, for: axis)
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
    public func northLayoutFormat(_ metrics: [String: CGFloat], _ views: [String: AnyObject], options: FormatOptions = []) -> (String) -> Void {
        for case let v as View in views.values {
            if !v.isDescendant(of: self) {
                v.translatesAutoresizingMaskIntoConstraints = false
                addSubview(v)
            }
        }
        return { (format: String) in
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics as [String : NSNumber]?, views: views))
        }
    }
}


#if os(iOS)
    extension UIViewController {
        /// autolayout by replacing vertical edges `|`...`|` to `topLayoutGuide` and `bottomLayoutGuide`
        public func northLayoutFormat(_ metrics: [String: CGFloat], _ views: [String: AnyObject], options: NSLayoutFormatOptions = []) -> (String) -> Void {
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
                    .replacingOccurrences(of: "V:|", with: "V:[topLayoutGuide]")
                    .replacingOccurrences(of: "|", with: "[bottomLayoutGuide]"))
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
    func setContentCompressionResistancePriority(_ priority: LayoutPriority, for axis: LayoutAxis)
    func setContentHuggingPriority(_ priority: LayoutPriority, for axis: LayoutAxis)
}


extension LayoutPriority {
    static var fitInWindow: LayoutPriority = LayoutPriority(500 - 1) // = NSLayoutPriorityWindowSizeStayPut - 1
    static var fittingSize: LayoutPriority = LayoutPriority(50)
}


// common setup for MinView
protocol MinLayoutable: LayoutPrioritizable {
    func setup()
}
extension MinLayoutable {
    func setup() {
        setContentCompressionResistancePriority(LayoutPriority.fittingSize, for: .horizontal)
        setContentCompressionResistancePriority(LayoutPriority.fittingSize, for: .vertical)
        setContentHuggingPriority(LayoutPriority.fitInWindow, for: .horizontal)
        setContentHuggingPriority(LayoutPriority.fitInWindow, for: .vertical)
    }
}
