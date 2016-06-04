//
//  ColorTransformer.swift
//  PubQuizzer
//
//  Created by Envato Tuts+ on 03/06/16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import UIKit


class ColorTransformer : NSValueTransformer {
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let colors = value as? [UIColor] else { return nil }
        return colors.colorData
    }

    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        guard let data = value as? NSData else { return nil }
        return data.colorValues
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override static func transformedValueClass() -> AnyClass {
        return NSData.self
    }
}


extension SequenceType where Generator.Element == UIColor {
    public var colorData : NSData {
        let rgbValues = flatMap { $0.rgbValues }
        return rgbValues.withUnsafeBufferPointer {
            return NSData(bytes: $0.baseAddress, length: $0.count)
        }
    }
}

extension UIColor {
    private var rgbValues : [UInt8] {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: nil)

        return [UInt8(red * 255), UInt8(green * 255), UInt8(blue * 255)]
    }

    private convenience init?(rawData: [UInt8]) {
        if rawData.count != 3 { return nil }
        let red = CGFloat(rawData[0]) / 255
        let green = CGFloat(rawData[1]) / 255
        let blue = CGFloat(rawData[2]) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension NSData {
    public var colorValues : [UIColor]? {
        guard length > 0 && length % 3 == 0 else { return nil }
        var rgbValues = Array(count: length, repeatedValue: UInt8())
        rgbValues.withUnsafeMutableBufferPointer { buffer -> () in
            let void = UnsafeMutablePointer<Void>(buffer.baseAddress)
            memcpy(void, bytes, length)
        }

        let rgbData = rgbValues.split(3)
        return rgbData.map { slice in
            guard let color = UIColor(rawData: Array(slice)) else {
                fatalError("Can't convert raw data into color")
            }
            return color
        }
    }
}