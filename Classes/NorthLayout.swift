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
        public func northLayoutFormat(_ metrics: [String: CGFloat], _ views: [String: AnyObject], options: NSLayoutFormatOptions = [], useSafeArea: Bool = true) -> (String) -> Void {
            guard let view = view else { fatalError() }
            guard view.enclosingScrollView == nil else {
                // fallback to the view.northLayoutFormat because UIScrollView.contentSize is measured by its layout but not by the layout guides of this view controller
                return view.northLayoutFormat(metrics, views, options: options)
            }

            var vs = views
            vs["topLayoutGuide"] = topLayoutGuide
            vs["bottomLayoutGuide"] = bottomLayoutGuide
            let autolayout = view.northLayoutFormat(metrics, vs, options: options)
            let autolayoutWithVerticalGuides: (String) -> Void = { format in
                autolayout(!format.hasPrefix("V:") ? format : format
                    .replacingOccurrences(of: "V:|", with: "V:[topLayoutGuide]")
                    .replacingOccurrences(of: "|", with: "[bottomLayoutGuide]"))
            }

            guard #available(iOS 11, tvOS 11, *), useSafeArea else { return autolayoutWithVerticalGuides }
            let safeAreaLayoutGuide = view.safeAreaLayoutGuide

            return { (format: String) in
                let replacedFormat = NSMutableString(string: format)

                func edgeConstraints(pattern: String) -> (view: UIView, constraint: (NSLayoutXAxisAnchor, NSLayoutXAxisAnchor) -> [NSLayoutConstraint])? {
                    let regex = try! NSRegularExpression(pattern: pattern)
                    return regex.firstMatch(in: String(replacedFormat), range: NSRange(location: 0, length: replacedFormat.length)).flatMap { result in
                        guard result.range.location != NSNotFound else { return nil }

                        let connection = result.range(withName: "connection")
                        let predicateList = result.range(withName: "predicateList")
                        var predicates: [(relation: NSLayoutRelation, margin: CGFloat, priority: LayoutPriority?)] = []
                        if predicateList.location != NSNotFound {
                            // "|-...-[..." or "...]-...-|"
                            let predicatesText = replacedFormat.substring(with: predicateList)
                            if let simplePredicate = (metrics[predicatesText] ?? Double(predicatesText).map {CGFloat($0)}) {
                                predicates = [(.equal, simplePredicate, nil)]
                            } else {
                                let predicatesTexts = predicatesText.trimmingCharacters(in: CharacterSet(charactersIn: "()")).split(separator: ",").map {$0.trimmingCharacters(in: .whitespaces)}
                                // (<relation>)?(<objectOfPredicate>)(@<priority>)?
                                let pat = try! NSRegularExpression(pattern: "(?<relation>(==|<=|>=))?(?<constant>[_0-9a-zA-Z]+)(@(?<priority>[_0-9a-zA-Z]+))?")
                                predicates = predicatesTexts.flatMap { s in
                                    pat.matches(in: s, range: NSRange(location: 0, length: NSString(string: s).length)).flatMap { result in
                                        guard result.range.location != NSNotFound else { return nil }
                                        let relationText = NSString(string: s).substring(with: result.range(withName: "relation"))
                                        let constantText = NSString(string: s).substring(with: result.range(withName: "constant")) // metricName | number
                                        let priorityText = result.range(withName: "priority").location == NSNotFound ? nil : NSString(string: s).substring(with: result.range(withName: "priority")) // metricName | number
                                        let relation: NSLayoutRelation
                                        switch relationText {
                                        case "<=": relation = .lessThanOrEqual
                                        case "==": relation = .equal
                                        case ">=": relation = .greaterThanOrEqual
                                        default: fatalError()
                                        }
                                        let margin = (metrics[constantText] ?? Double(constantText).map {CGFloat($0)})!
                                        let priority = priorityText.map {LayoutPriority(rawValue: metrics[$0].map {Float($0)} ?? Float($0)!)}
                                        return (relation, margin, priority)
                                    }
                                }
                            }
                        } else {
                            // "|[..." or "...]|"
                            // "|-[..." or "...]-|"
                            let systemSpacing = 8
                            let margin = CGFloat(connection.length == 0 ? 0 : systemSpacing)
                            predicates = [(.equal, margin, nil)]
                        }

                        let edgeViewName = replacedFormat.substring(with: result.range(withName: "view"))
                        guard let edgeView = views[edgeViewName] as? UIView else { return nil }

                        replacedFormat.replaceCharacters(in: result.range(withName: "removed"), with: "")
                        return (edgeView, { lhs, rhs in
                            predicates.map { relation, margin, priority in
                                let constraint: NSLayoutConstraint
                                switch relation {
                                case .lessThanOrEqual:
                                    constraint = lhs.constraint(lessThanOrEqualTo: rhs, constant: margin)
                                case .equal:
                                    constraint = lhs.constraint(equalTo: rhs, constant: margin)
                                case .greaterThanOrEqual:
                                    constraint = lhs.constraint(greaterThanOrEqualTo: rhs, constant: margin)
                                }
                                _ = priority.map {constraint.priority = $0}
                                return constraint
                            }
                        })
                    }
                }

                if let left = edgeConstraints(pattern: "^(H:|)(?<removed>\\|(?<connection>|-(?<predicateList>[_0-9a-zA-Z(><=,@)]+)-|-))\\[(?<view>[_0-9a-zA-Z]+)") {
                    left.constraint(left.view.leftAnchor, safeAreaLayoutGuide.leftAnchor).forEach {$0.isActive = true}
                }
                if let right = edgeConstraints(pattern: "^(H:|)[^:]*\\[(?<view>[_0-9a-zA-Z]+).*\\](?<removed>(?<connection>|-(?<predicateList>[_0-9a-zA-Z(><=,@)]+)-|-)\\|)$") {
                    right.constraint(safeAreaLayoutGuide.rightAnchor, right.view.rightAnchor).forEach {$0.isActive = true}
                }

                autolayoutWithVerticalGuides(String(replacedFormat))
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
        setContentCompressionResistancePriority(.fittingSize, for: .horizontal)
        setContentCompressionResistancePriority(.fittingSize, for: .vertical)
        setContentHuggingPriority(.fitInWindow, for: .horizontal)
        setContentHuggingPriority(.fitInWindow, for: .vertical)
    }
}
