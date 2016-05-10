//
//  Energy.swift
//  Scale
//
//  Original from Khoa Pham
//  Updated by Jason Jobe
//  Copyright © 2016. See LICENSE
//

import Foundation

public enum EnergyUnit: Double {
    case joule = 1
    case kilojoule = 1_000
    case gramcalorie = 4.184
    case kilocalorie = 4_184
    case watthour = 3_600

    static var defaultScale: Double {
        return EnergyUnit.joule.rawValue
    }
}

public struct Energy: CustomStringConvertible {
    public let value: Double
    public let unit: EnergyUnit

    public init(value: Double, unit: EnergyUnit) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: EnergyUnit) -> Energy {
        return Energy(value: self.value * self.unit.rawValue * EnergyUnit.joule.rawValue / unit.rawValue, unit: unit)
    }

    public var description: String {
        return "\(value)_\(unit)"
    }
}

public extension Double {
    public var joule: Energy {
        return Energy(value: self, unit: .joule)
    }

    public var kilojoule: Energy {
        return Energy(value: self, unit: .kilojoule)
    }

    public var gramcalorie: Energy {
        return Energy(value: self, unit: .gramcalorie)
    }

    public var kilocalorie: Energy {
        return Energy(value: self, unit: .kilocalorie)
    }

    public var watthour: Energy {
        return Energy(value: self, unit: .watthour)
    }
}

public func compute(left: Energy, right: Energy, operation: (Double, Double) -> Double) -> Energy {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return Energy(value: result, unit: min.unit)
}

// + and - must be Unit Compatible
public func +(left: Energy, right: Energy) -> Energy {
    return compute(left, right: right, operation: +)
}

public func -(left: Energy, right: Energy) -> Energy {
    return compute(left, right: right, operation: -)
}


// * and / _scale_ the unit value
// For example
// 10 meters * 10 meters != 100 meters ! It should equal the AREA 100 square_meters
// BUT, 10_meters * 5 => 50_meters

public func *(left: Energy, right: Double) -> Energy {
    return  Energy(value: left.value * right, unit: left.unit)
}

public func /(left: Energy, right: Double) throws -> Energy {
    guard right != 0 else {
        throw Error.DividedByZero
    }

    return  Energy(value: left.value / right, unit: left.unit)
}
