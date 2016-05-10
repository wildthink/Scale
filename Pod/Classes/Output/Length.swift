//
//  Length.swift
//  Scale
//
//  Original from Khoa Pham
//  Updated by Jason Jobe
//  Copyright © 2016. See LICENSE
//

import Foundation

public enum LengthUnit: Double {
    case millimeter = 0.001
    case centimeter = 0.01
    case decimeter = 0.1
    case meter = 1
    case dekameter = 10
    case hectometer = 100
    case kilometer = 1_000
    case yard = 0.914_4
    case parsec = 30_856_775_813_060_000
    case mile = 1_609.344
    case foot = 0.304_8
    case fathom = 1.828_8
    case inch = 0.025_4
    case league = 4_828.032

    static var defaultScale: Double {
        return LengthUnit.meter.rawValue
    }
}

public struct Length: CustomStringConvertible {
    public let value: Double
    public let unit: LengthUnit

    public init(value: Double, unit: LengthUnit) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: LengthUnit) -> Length {
        return Length(value: self.value * self.unit.rawValue * LengthUnit.meter.rawValue / unit.rawValue, unit: unit)
    }

    public var description: String {
        return "\(value)_\(unit)"
    }
}

public extension Double {
    public var millimeter: Length {
        return Length(value: self, unit: .millimeter)
    }

    public var centimeter: Length {
        return Length(value: self, unit: .centimeter)
    }

    public var decimeter: Length {
        return Length(value: self, unit: .decimeter)
    }

    public var meter: Length {
        return Length(value: self, unit: .meter)
    }

    public var dekameter: Length {
        return Length(value: self, unit: .dekameter)
    }

    public var hectometer: Length {
        return Length(value: self, unit: .hectometer)
    }

    public var kilometer: Length {
        return Length(value: self, unit: .kilometer)
    }

    public var yard: Length {
        return Length(value: self, unit: .yard)
    }

    public var parsec: Length {
        return Length(value: self, unit: .parsec)
    }

    public var mile: Length {
        return Length(value: self, unit: .mile)
    }

    public var foot: Length {
        return Length(value: self, unit: .foot)
    }

    public var fathom: Length {
        return Length(value: self, unit: .fathom)
    }

    public var inch: Length {
        return Length(value: self, unit: .inch)
    }

    public var league: Length {
        return Length(value: self, unit: .league)
    }
}

public func compute(left: Length, right: Length, operation: (Double, Double) -> Double) -> Length {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return Length(value: result, unit: min.unit)
}

// + and - must be Unit Compatible
public func +(left: Length, right: Length) -> Length {
    return compute(left, right: right, operation: +)
}

public func -(left: Length, right: Length) -> Length {
    return compute(left, right: right, operation: -)
}


// * and / _scale_ the unit value
// For example
// 10 meters * 10 meters != 100 meters ! It should equal the AREA 100 square_meters
// BUT, 10_meters * 5 => 50_meters

public func *(left: Length, right: Double) -> Length {
    return  Length(value: left.value * right, unit: left.unit)
}

public func /(left: Length, right: Double) throws -> Length {
    guard right != 0 else {
        throw Error.DividedByZero
    }

    return  Length(value: left.value / right, unit: left.unit)
}
