//
//  <<Name>>.swift
//  Scale
//
//  Original from Khoa Pham
//  Updated by Jason Jobe
//  Copyright © 2016. See LICENSE
//

import Foundation

<<Def>>

public struct <<Name>>: CustomStringConvertible {
    public let value: Double
    public let unit: <<UnitName>>

    public init(value: Double, unit: <<UnitName>>) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: <<UnitName>>) -> <<Name>> {
        return <<Name>>(value: self.value * self.unit.rawValue * <<UnitName>>.<<DefaultScale>>.rawValue / unit.rawValue, unit: unit)
    }

    public var description: String {
        return "\(value)_\(unit)"
    }
}

public extension Double {
<<Units>>
}

public func compute(left: <<Name>>, right: <<Name>>, operation: (Double, Double) -> Double) -> <<Name>> {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return <<Name>>(value: result, unit: min.unit)
}

// + and - must be Unit Compatible
public func +(left: <<Name>>, right: <<Name>>) -> <<Name>> {
    return compute(left, right: right, operation: +)
}

public func -(left: <<Name>>, right: <<Name>>) -> <<Name>> {
    return compute(left, right: right, operation: -)
}


// * and / _scale_ the unit value
// For example
// 10 meters * 10 meters != 100 meters ! It should equal the AREA 100 square_meters
// BUT, 10_meters * 5 => 50_meters

public func *(left: <<Name>>, right: Double) -> <<Name>> {
    return  <<Name>>(value: left.value * right, unit: left.unit)
}

public func /(left: <<Name>>, right: Double) throws -> <<Name>> {
    guard right != 0 else {
        throw Error.DividedByZero
    }

    return  <<Name>>(value: left.value / right, unit: left.unit)
}
