//
//  Array+RI.swift
//  Pods
//
//  Created by Nagumo, Jin on 1/26/17.
//
//

extension Array where Element: Equatable {
    
    public mutating func ri_remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
    public mutating func ri_substracting(array: Array) {
        self = self.filter { !array.contains($0) }
    }
    
    public func ri_removedDuplicate() -> [Element] {
        return self.reduce([Element]()) { (result, element) -> [Element] in
            var newResult = result
            if result.contains(element) == false {
                newResult.append(element)
            }
            return newResult
        }
    }
    
    public static func ri_compare(_ lhs: [Element]?, _ rhs: [Element]?) -> Bool {
        switch (lhs, rhs) {
        case (.some(let l), .some(let r)):
            return l == r
        case (nil, nil):
            return true
        default:
            return false
        }
    }
}

extension Array where Element == Int {
    
    public var ri_range: CountableRange<Int>? {
        let nonSortedDuplicated = ri_removedDuplicate().sorted()
        if nonSortedDuplicated.count > 1, let min = first, let max = last {
            return (min..<(max + 1))
        }
        return nil
    }
    
}

extension CountableRange where Bound == Int {
    
    public var ri_array: Array<Int> {
        var result = [Int]()
        for i in lowerBound..<upperBound {
            result.append(i)
        }
        return result
    }
    
}
