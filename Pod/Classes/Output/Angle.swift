//
//  Angle.swift
//  Scale
//
//  Original from Khoa Pham
//  Updated by Jason Jobe
//  Copyright © 2016. See LICENSE
//

import Foundation

public enum AngleUnit: Double {
    case degree = 1
    case radian = 57.295_8
    case pi = 180

    static var defaultScale: Double {
        return AngleUnit.degree.rawValue
    }
}

public struct Angle: CustomStringConvertible {
    public let value: Double
    public let unit: AngleUnit

    public init(value: Double, unit: AngleUnit) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: AngleUnit) -> Angle {
        return Angle(value: self.value * self.unit.rawValue * AngleUnit.degree.rawValue / unit.rawValue, unit: unit)
    }

    public var description: String {
        return "\(value)_\(unit)"
    }
}

public extension Double {
    public var degree: Angle {
        return Angle(value: self, unit: .degree)
    }

    public var radian: Angle {
        return Angle(value: self, unit: .radian)
    }

    public var pi: Angle {
        return Angle(value: self, unit: .pi)
    }
}

public func compute(left: Angle, right: Angle, operation: (Double, Double) -> Double) -> Angle {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return Angle(value: result, unit: min.unit)
}

// + and - must be Unit Compatible
public func +(left: Angle, right: Angle) -> Angle {
    return compute(left, right: right, operation: +)
}

public func -(left: Angle, right: Angle) -> Angle {
    return compute(left, right: right, operation: -)
}


// * and / _scale_ the unit value
// For example
// 10 meters * 10 meters != 100 meters ! It should equal the AREA 100 square_meters
// BUT, 10_meters * 5 => 50_meters

public func *(left: Angle, right: Double) -> Angle {
    return  Angle(value: left.value * right, unit: left.unit)
}

public func /(left: Angle, right: Double) throws -> Angle {
    guard right != 0 else {
        throw Error.DividedByZero
    }

    return  Angle(value: left.value / right, unit: left.unit)
}
