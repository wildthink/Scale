//
//  Time.swift
//  Scale
//
//  Original from Khoa Pham
//  Updated by Jason Jobe
//  Copyright © 2016. See LICENSE
//

import Foundation

public enum TimeUnit: Double {
    case nanosecond = 0.000_000_001
    case microsecond = 0.000_001
    case millisecond = 0.001
    case centisecond = 0.01
    case second = 1
    case minute = 60
    case hour = 3_600
    case day = 86_400
    case week = 604_800
    case fortnight = 1_209_600
    case month = 2_629_822.965_84
    case year = 31_536_000
    case decade = 315_360_000
    case century = 3_153_600_000
    case millennium = 31_536_000_000

    static var defaultScale: Double {
        return TimeUnit.second.rawValue
    }
}

public struct Time: CustomStringConvertible {
    public let value: Double
    public let unit: TimeUnit

    public init(value: Double, unit: TimeUnit) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: TimeUnit) -> Time {
        return Time(value: self.value * self.unit.rawValue * TimeUnit.second.rawValue / unit.rawValue, unit: unit)
    }

    public var description: String {
        return "\(value)_\(unit)"
    }
}

public extension Double {
    public var nanosecond: Time {
        return Time(value: self, unit: .nanosecond)
    }

    public var microsecond: Time {
        return Time(value: self, unit: .microsecond)
    }

    public var millisecond: Time {
        return Time(value: self, unit: .millisecond)
    }

    public var centisecond: Time {
        return Time(value: self, unit: .centisecond)
    }

    public var second: Time {
        return Time(value: self, unit: .second)
    }

    public var minute: Time {
        return Time(value: self, unit: .minute)
    }

    public var hour: Time {
        return Time(value: self, unit: .hour)
    }

    public var day: Time {
        return Time(value: self, unit: .day)
    }

    public var week: Time {
        return Time(value: self, unit: .week)
    }

    public var fortnight: Time {
        return Time(value: self, unit: .fortnight)
    }

    public var month: Time {
        return Time(value: self, unit: .month)
    }

    public var year: Time {
        return Time(value: self, unit: .year)
    }

    public var decade: Time {
        return Time(value: self, unit: .decade)
    }

    public var century: Time {
        return Time(value: self, unit: .century)
    }

    public var millennium: Time {
        return Time(value: self, unit: .millennium)
    }
}

public func compute(left: Time, right: Time, operation: (Double, Double) -> Double) -> Time {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return Time(value: result, unit: min.unit)
}

// + and - must be Unit Compatible
public func +(left: Time, right: Time) -> Time {
    return compute(left, right: right, operation: +)
}

public func -(left: Time, right: Time) -> Time {
    return compute(left, right: right, operation: -)
}


// * and / _scale_ the unit value
// For example
// 10 meters * 10 meters != 100 meters ! It should equal the AREA 100 square_meters
// BUT, 10_meters * 5 => 50_meters

public func *(left: Time, right: Double) -> Time {
    return  Time(value: left.value * right, unit: left.unit)
}

public func /(left: Time, right: Double) throws -> Time {
    guard right != 0 else {
        throw Error.DividedByZero
    }

    return  Time(value: left.value / right, unit: left.unit)
}
