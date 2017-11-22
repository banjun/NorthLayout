//
//  VFLSyntaxTests.swift
//  NorthLayout-ios-Tests
//
//  Created by BAN Jun on 2017/11/22.
//  Copyright © 2017 banjun. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import NorthLayout

public func equal(_ expectedValue: VFL.PredicateList) -> Predicate<VFL.PredicateList> {
    let expectedDescription = String(describing: expectedValue)
    return .define {
        .init(bool: (try $0.evaluate()).map {String(describing: $0)} == expectedDescription,
              message: ExpectationMessage.expectedActualValueTo("equal <\(expectedDescription)>"))
    }
}

final class VFLSyntaxTests: QuickSpec {
    override func spec() {
        describe("VFL Parse") {
            context("orientation") {
                it("implicit -> h") {
                    expect(try? VFL(format: "[v]").orientation) == .h
                }
                it("H: orientation is h") {
                    expect(try? VFL(format: "H:[v]").orientation) == .h
                }
                it("V: orientation is v") {
                    expect(try? VFL(format: "V:[v]").orientation) == .v
                }
            }
            context("firstBound") {
                it("nil") {
                    let b = try! VFL(format: "H:[v]").firstBound
                    expect(b).to(beNil())
                }
                it("zero width") {
                    let b = try! VFL(format: "H:|[v]").firstBound
                    expect(b).notTo(beNil())
                    expect(b!.0).to(equal(VFL.Bound.superview))
                    expect(b!.1.predicateList).to(equal(.simplePredicate(.positiveNumber(0))))
                }
                it("system width") {
                    let b = try! VFL(format: "H:|-[v]").firstBound
                    expect(b).notTo(beNil())
                    expect(b!.0).to(equal(VFL.Bound.superview))
                    expect(b!.1.predicateList).to(equal(.simplePredicate(.positiveNumber(8))))
                }
                it("constant width") {
                    let b = try! VFL(format: "H:|-42-[v]").firstBound
                    expect(b).notTo(beNil())
                    expect(b!.0).to(equal(VFL.Bound.superview))
                    expect(b!.1.predicateList).to(equal(.simplePredicate(.positiveNumber(42))))
                }
                it("metric width") {
                    let b = try! VFL(format: "H:|-p-[v]").firstBound
                    expect(b).notTo(beNil())
                    expect(b!.0).to(equal(VFL.Bound.superview))
                    expect(b!.1.predicateList).to(equal(.simplePredicate(.metricName("p"))))
                }
                it(">= width") {
                    let b = try! VFL(format: "H:|-(>=0)-[v]").firstBound
                    expect(b).notTo(beNil())
                    expect(b!.0).to(equal(VFL.Bound.superview))
                    expect(b!.1.predicateList).to(equal(.predicateListWithParens([VFL.Predicate(relation: .ge, objectOfPredicate: .constant(.number(0)), priority: nil)])))
                }
                it(">=,<= width") {
                    let b = try! VFL(format: "H:|-(>=0,<=100)-[v]").firstBound
                    expect(b).notTo(beNil())
                    expect(b!.0).to(equal(VFL.Bound.superview))
                    expect(b!.1.predicateList).to(equal(.predicateListWithParens([
                        VFL.Predicate(relation: .ge, objectOfPredicate: .constant(.number(0)), priority: nil),
                        VFL.Predicate(relation: .le, objectOfPredicate: .constant(.number(100)), priority: nil)])))
                }
            }
            context("firstView") {
                it("various bounds") {
                    expect {try VFL(format: "|[v]").firstView.name} == "v"
                    expect {try VFL(format: "|-[v]").firstView.name} == "v"
                    expect {try VFL(format: "|-42-[v]").firstView.name} == "v"
                    expect {try VFL(format: "|-(>=p)-[v]").firstView.name} == "v"
                    expect {try VFL(format: "|-(>=0,<=100)-[v]").firstView.name} == "v"
                }
            }
            context("lastBound") {
                it("nil") {
                    let b = try! VFL(format: "H:[v]").lastBound
                    expect(b).to(beNil())
                }
                it("zero width") {
                    let b = try! VFL(format: "H:[v]|").lastBound
                    expect(b).notTo(beNil())
                    expect(b!.1).to(equal(VFL.Bound.superview))
                    expect(b!.0.predicateList).to(equal(.simplePredicate(.positiveNumber(0))))
                }
                it("system width") {
                    let b = try! VFL(format: "H:[v]-|").lastBound
                    expect(b).notTo(beNil())
                    expect(b!.1).to(equal(VFL.Bound.superview))
                    expect(b!.0.predicateList).to(equal(.simplePredicate(.positiveNumber(8))))
                }
                it("constant width") {
                    let b = try! VFL(format: "H:[v]-42-|").lastBound
                    expect(b).notTo(beNil())
                    expect(b!.1).to(equal(VFL.Bound.superview))
                    expect(b!.0.predicateList).to(equal(.simplePredicate(.positiveNumber(42))))
                }
                it("metric width") {
                    let b = try! VFL(format: "H:[v]-p-|").lastBound
                    expect(b).notTo(beNil())
                    expect(b!.1).to(equal(VFL.Bound.superview))
                    expect(b!.0.predicateList).to(equal(.simplePredicate(.metricName("p"))))
                }
                it(">= width") {
                    let b = try! VFL(format: "H:[v]-(>=0)-|").lastBound
                    expect(b).notTo(beNil())
                    expect(b!.1).to(equal(VFL.Bound.superview))
                    expect(b!.0.predicateList).to(equal(.predicateListWithParens([VFL.Predicate(relation: .ge, objectOfPredicate: .constant(.number(0)), priority: nil)])))
                }
                it(">=,<= width") {
                    let b = try! VFL(format: "H:[v]-(>=0,<=100)-|").lastBound
                    expect(b).notTo(beNil())
                    expect(b!.1).to(equal(VFL.Bound.superview))
                    expect(b!.0.predicateList).to(equal(.predicateListWithParens([
                        VFL.Predicate(relation: .ge, objectOfPredicate: .constant(.number(0)), priority: nil),
                        VFL.Predicate(relation: .le, objectOfPredicate: .constant(.number(100)), priority: nil)])))
                }
            }
            context("lastView") {
                it("various bounds") {
                    expect {try VFL(format: "[v]|").lastView.name} == "v"
                    expect {try VFL(format: "[v]-|").lastView.name} == "v"
                    expect {try VFL(format: "[v]-42-|").lastView.name} == "v"
                    expect {try VFL(format: "[v]-(>=p)-|").lastView.name} == "v"
                    expect {try VFL(format: "[v]-(>=0,<=100)-|").lastView.name} == "v"
                }
            }
        }

        describe("Extended VFL Parse (|| layout margin)") {
            it("first bound") {
                expect {try VFL(format: "||[v]").firstBound?.0} == .layoutMargin
                expect {try VFL(format: "H:||[v]").firstBound?.0} == .layoutMargin
                expect {try VFL(format: "V:||[v]").firstBound?.0} == .layoutMargin
            }
            it("last bound") {
                expect {try VFL(format: "[v]||").lastBound?.1} == .layoutMargin
                expect {try VFL(format: "H:[v]||").lastBound?.1} == .layoutMargin
                expect {try VFL(format: "V:[v]||").lastBound?.1} == .layoutMargin
            }
        }
    }
}
