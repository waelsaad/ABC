// Copyright © 2018 NetTrinity Pty Ltd. All rights reserved.

public protocol CountableEnumeration {
    static var count: Int { get }
}

public extension CountableEnumeration where Self: RawRepresentable, Self.RawValue == Int {
    static var count: Int {
        var count = 0
        while Self(rawValue: count) != nil { count += 1 }
        return count
    }
}
