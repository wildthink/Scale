//
//  Area.swift
//  Scale
//
//  Original from Khoa Pham
//  Updated by Jason Jobe
//  Copyright © 2016. See LICENSE
//

import Foundation

public enum AreaUnit: Double {
    case squareFoot = 0.092_903
    case squareYard = 0.836_127
    case squareMeter = 1
    case squareKilometer = 1_000_000
    case squareMile = 2_589_988.11
    case acre = 4_046.86
    case hectare = 10_000

    static var defaultScale: Double {
        return AreaUnit.squareMeter.rawValue
    }
}

public struct Area: CustomStringConvertible {
    public let value: Double
    public let unit: AreaUnit

    public init(value: Double, unit: AreaUnit) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: AreaUnit) -> Area {
        return Area(value: self.value * self.unit.rawValue * AreaUnit.squareMeter.rawValue / unit.rawValue, unit: unit)
    }

    public var description: String {
        return "\(value)_\(unit)"
    }
}

public extension Double {
    public var squareFoot: Area {
        return Area(value: self, unit: .squareFoot)
    }

    public var squareYard: Area {
        return Area(value: self, unit: .squareYard)
    }

    public var squareMeter: Area {
        return Area(value: self, unit: .squareMeter)
    }

    public var squareKilometer: Area {
        return Area(value: self, unit: .squareKilometer)
    }

    public var squareMile: Area {
        return Area(value: self, unit: .squareMile)
    }

    public var acre: Area {
        return Area(value: self, unit: .acre)
    }

    public var hectare: Area {
        return Area(value: self, unit: .hectare)
    }
}

public func compute(left: Area, right: Area, operation: (Double, Double) -> Double) -> Area {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return Area(value: result, unit: min.unit)
}

// + and - must be Unit Compatible
public func +(left: Area, right: Area) -> Area {
    return compute(left, right: right, operation: +)
}

public func -(left: Area, right: Area) -> Area {
    return compute(left, right: right, operation: -)
}


// * and / _scale_ the unit value
// For example
// 10 meters * 10 meters != 100 meters ! It should equal the AREA 100 square_meters
// BUT, 10_meters * 5 => 50_meters

public func *(left: Area, right: Double) -> Area {
    return  Area(value: left.value * right, unit: left.unit)
}

public func /(left: Area, right: Double) throws -> Area {
    guard right != 0 else {
        throw Error.DividedByZero
    }

    return  Area(value: left.value / right, unit: left.unit)
}
