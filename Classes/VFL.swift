import Foundation

extension VFL {
    /// decompose visual format into both side of edge connections and a middle remainder format string
    func edgeDecomposed(format: String) throws -> (first: (Connection, VFL.View)?, middle: String, last: (Connection, VFL.View)?) {
        var middle = format
        let vfl = try VFL(format: format)
        guard case .h = vfl.orientation else { return (nil, format, nil) } // only support horizontals

        let first = vfl.firstBound.map {($0, vfl.firstView)}
        let last = vfl.lastBound.map {($0, vfl.lastView)}

        // strip decomposed edge connections
        // we do not generate a format string from parsed VFL, for some reliability
        // instead, use a knowledge that first `[` and last `]` separate edge connections
        if first != nil {
            middle = String(middle.drop {$0 != "["})
        }
        if last != nil {
            middle = String(middle.reversed().drop {$0 != "]"}.reversed())
        }

        return (first, middle, last)
    }
}

extension VFL.SimplePredicate {
    func value(_ metrics: [String: CGFloat]) -> CGFloat? {
        switch self {
        case let .metricName(n): return metrics[n]
        case let .positiveNumber(v): return v
        }
    }
}

extension VFL.Constant {
    func value(_ metrics: [String: CGFloat]) -> CGFloat? {
        switch self {
        case let .metricName(n): return metrics[n]
        case let .number(v): return v
        }
    }
}

extension VFL.Priority {
    func value(_ metrics: [String: CGFloat]) -> CGFloat? {
        switch self {
        case let .metricName(n): return metrics[n]
        case let .number(v): return v
        }
    }
}

extension VFL.PredicateList {
    /// returns constraints: `lhs (==|<=|>=) rhs + constant`
    @discardableResult
    func constraints<T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>, metrics: [String: CGFloat]) -> [NSLayoutConstraint] {
        let cs: [NSLayoutConstraint]
        switch self {
        case let .simplePredicate(p):
            guard let constant = p.value(metrics) else { return [] }
            cs = [lhs.constraint(equalTo: rhs, constant: constant)]
        case let .predicateListWithParens(predicates):
            cs = predicates.flatMap { p in
                guard case let .constant(c) = p.objectOfPredicate else { return nil } // NOTE: For the objectOfPredicate production, viewName is acceptable only if the subject of the predicate is the width or height of a view
                guard let constant = c.value(metrics) else { return nil }

                let constraint: NSLayoutConstraint
                switch p.relation {
                case .eq?, nil:
                    constraint = lhs.constraint(equalTo: rhs, constant: constant)
                case .le?:
                    constraint = lhs.constraint(lessThanOrEqualTo: rhs, constant: constant)
                case .ge?:
                    constraint = lhs.constraint(greaterThanOrEqualTo: rhs, constant: constant)
                }
                _ = p.priority?.value(metrics).map {constraint.priority = LayoutPriority(rawValue: Float($0))}
                return constraint
            }
        }
        cs.forEach {$0.isActive = true}
        return cs
    }
}
