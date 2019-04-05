//
//  RMEncodedColorTransformer.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/5/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

class RMEncodedColorTransformer: ValueTransformer {
    static func colorFromInt(_ rawValue: Int) -> NSColor {
        // 32-bit RGB encoding; no alpha...I might have to re-think this.
        let r: CGFloat = CGFloat(UInt8(rawValue >> 16)) / 255.0
        let g: CGFloat = CGFloat(UInt8(rawValue >> 8)) / 255.0
        let b: CGFloat = CGFloat(UInt8(rawValue >> 0)) / 255.0
        return NSColor(srgbRed: r, green: g, blue: b, alpha: 1.0)
    }
    
    
    static func intFromColor(_ color: NSColor) -> Int32 {
        if let c = color.usingColorSpace(NSColorSpace.sRGB) {
            let r: Int32 = Int32(UInt8(c.redComponent*255))
            let g: Int32 = Int32(UInt8(c.greenComponent*255))
            let b: Int32 = Int32(UInt8(c.blueComponent*255))
            let result: Int32 = r << 16 | g << 8 | b;
            return result
        } else {
            // Maybe fail?
            assert(false, "can't convert color")
            return 0
        }
    }
}

/*

+ (int)intFromColor:(NSColor *)color {
    NSColor *c = [color colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    CGFloat r, g, b, a;
    [c getRed:&r green:&g blue:&b alpha:&a];
    uint8_t r8 = r*255;
    uint8_t g8 = g*255;
    uint8_t b8 = b*255;
    uint32_t resInt = r8 << 16 | g8 << 8 | b8;
    return resInt;
}

+ (NSColor *)colorFromCRGBColor:(CRGB)color {
    return [NSColor colorWithSRGBRed:color.r/255.0 green:color.g/255.0 blue:color.b/255.0 alpha:1];
}

- (id)transformedValue:(id)value {
    if (value != nil) {
        NSAssert([value isKindOfClass:[NSNumber class]], @"class check");
        return [[self class] colorFromInt:[value intValue]];
    } else {
        return nil;
    }
}

- (id)reverseTransformedValue:(id)value {
    if (value != nil) {
        NSAssert([value isKindOfClass:[NSColor class]], @"should be a color");
        uint32_t resInt = [[self class] intFromColor:(NSColor *)value];
        return [NSNumber numberWithInt:resInt];
    } else {
        return nil;
    }
}




*/
