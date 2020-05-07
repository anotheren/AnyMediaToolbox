//
//  Ex+CMBlockBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/22.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation
import CoreMedia

extension CMBlockBuffer {
    
    public var data: Data? {
        var length: Int = 0
        var buffer: UnsafeMutablePointer<Int8>?
        if CMBlockBufferGetDataPointer(self, atOffset: 0, lengthAtOffsetOut: nil, totalLengthOut: &length, dataPointerOut: &buffer) == noErr, let buffer = buffer {
            return Data(bytes: buffer, count: length)
        }
        return nil
    }
}
