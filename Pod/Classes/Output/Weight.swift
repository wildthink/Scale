//
//  Weight.swift
//  Scale
//
//  Original from Khoa Pham
//  Updated by Jason Jobe
//  Copyright © 2016. See LICENSE
//

import Foundation

public enum WeightUnit: Double {
    case milligram = 0.001
    case centigram = 0.01
    case decigram = 0.1
    case gram = 1
    case dekagram = 10
    case hectogram = 100
    case kilogram = 1_000
    case ton = 1_000_000
    case carat = 0.2
    case newton = 101.971_621_297_8
    case ounce = 28.349_523_125
    case pound = 453.592_37
    case stone = 6_350.293_18 

    static var defaultScale: Double {
        return WeightUnit.gram.rawValue
    }
}

public struct Weight: CustomStringConvertible {
    public let value: Double
    public let unit: WeightUnit

    public init(value: Double, unit: WeightUnit) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: WeightUnit) -> Weight {
        return Weight(value: self.value * self.unit.rawValue * WeightUnit.gram.rawValue / unit.rawValue, unit: unit)
    }

    public var description: String {
        return "\(value)_\(unit)"
    }
}

public extension Double {
    public var milligram: Weight {
        return Weight(value: self, unit: .milligram)
    }

    public var centigram: Weight {
        return Weight(value: self, unit: .centigram)
    }

    public var decigram: Weight {
        return Weight(value: self, unit: .decigram)
    }

    public var gram: Weight {
        return Weight(value: self, unit: .gram)
    }

    public var dekagram: Weight {
        return Weight(value: self, unit: .dekagram)
    }

    public var hectogram: Weight {
        return Weight(value: self, unit: .hectogram)
    }

    public var kilogram: Weight {
        return Weight(value: self, unit: .kilogram)
    }

    public var ton: Weight {
        return Weight(value: self, unit: .ton)
    }

    public var carat: Weight {
        return Weight(value: self, unit: .carat)
    }

    public var newton: Weight {
        return Weight(value: self, unit: .newton)
    }

    public var ounce: Weight {
        return Weight(value: self, unit: .ounce)
    }

    public var pound: Weight {
        return Weight(value: self, unit: .pound)
    }

    public var stone: Weight {
        return Weight(value: self, unit: .stone)
    }
}

public func compute(left: Weight, right: Weight, operation: (Double, Double) -> Double) -> Weight {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return Weight(value: result, unit: min.unit)
}

// + and - must be Unit Compatible
public func +(left: Weight, right: Weight) -> Weight {
    return compute(left, right: right, operation: +)
}

public func -(left: Weight, right: Weight) -> Weight {
    return compute(left, right: right, operation: -)
}


// * and / _scale_ the unit value
// For example
// 10 meters * 10 meters != 100 meters ! It should equal the AREA 100 square_meters
// BUT, 10_meters * 5 => 50_meters

public func *(left: Weight, right: Double) -> Weight {
    return  Weight(value: left.value * right, unit: left.unit)
}

public func /(left: Weight, right: Double) throws -> Weight {
    guard right != 0 else {
        throw Error.DividedByZero
    }

    return  Weight(value: left.value / right, unit: left.unit)
}
