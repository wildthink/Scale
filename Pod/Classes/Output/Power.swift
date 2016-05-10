//
//  Power.swift
//  Scale
//
//  Original from Khoa Pham
//  Updated by Jason Jobe
//  Copyright © 2016. See LICENSE
//

import Foundation

public enum PowerUnit: Double {
    case milliwatt = 0.001
    case watt = 1
    case kilowatt = 1_000
    case megawatt = 1_000_000
    case gigawatt = 1_000_000_000
    case horsepower = 745.699_871_582_3

    static var defaultScale: Double {
        return PowerUnit.watt.rawValue
    }
}

public struct Power: CustomStringConvertible {
    public let value: Double
    public let unit: PowerUnit

    public init(value: Double, unit: PowerUnit) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: PowerUnit) -> Power {
        return Power(value: self.value * self.unit.rawValue * PowerUnit.watt.rawValue / unit.rawValue, unit: unit)
    }

    public var description: String {
        return "\(value)_\(unit)"
    }
}

public extension Double {
    public var milliwatt: Power {
        return Power(value: self, unit: .milliwatt)
    }

    public var watt: Power {
        return Power(value: self, unit: .watt)
    }

    public var kilowatt: Power {
        return Power(value: self, unit: .kilowatt)
    }

    public var megawatt: Power {
        return Power(value: self, unit: .megawatt)
    }

    public var gigawatt: Power {
        return Power(value: self, unit: .gigawatt)
    }

    public var horsepower: Power {
        return Power(value: self, unit: .horsepower)
    }
}

public func compute(left: Power, right: Power, operation: (Double, Double) -> Double) -> Power {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return Power(value: result, unit: min.unit)
}

// + and - must be Unit Compatible
public func +(left: Power, right: Power) -> Power {
    return compute(left, right: right, operation: +)
}

public func -(left: Power, right: Power) -> Power {
    return compute(left, right: right, operation: -)
}


// * and / _scale_ the unit value
// For example
// 10 meters * 10 meters != 100 meters ! It should equal the AREA 100 square_meters
// BUT, 10_meters * 5 => 50_meters

public func *(left: Power, right: Double) -> Power {
    return  Power(value: left.value * right, unit: left.unit)
}

public func /(left: Power, right: Double) throws -> Power {
    guard right != 0 else {
        throw Error.DividedByZero
    }

    return  Power(value: left.value / right, unit: left.unit)
}
