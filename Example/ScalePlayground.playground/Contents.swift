//: Playground - noun: a place where people can play

import UIKit
import Scale

//extension Scale.Time: CustomStringConvertible {
//    public var description: String {
//        return "\(value)_\(unit)"
//    }
//}
var str = "Hello, playground"

let t1 = 23.5.minute + 1.3.hour

t1

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

let a = [1, 2, 3, 4, 5]

a[0]
//a[9]
