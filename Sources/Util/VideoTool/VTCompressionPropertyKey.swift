//
//  VTCompressionPropertyKey.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/21.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import VideoToolbox

struct VTCompressionPropertyKey: RawRepresentable, Hashable {
    
    public let rawValue: CFString
    
    public init(rawValue: CFString) {
        self.rawValue = rawValue
    }
}

extension VTCompressionPropertyKey {
    
    public static let realTime: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_RealTime)
    public static let profileLevel: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_ProfileLevel)
    public static let averageBitRate: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_AverageBitRate)
    public static let expectedFrameRate: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_ExpectedFrameRate)
    public static let maxKeyFrameIntervalDuration: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration)
    public static let allowFrameReordering: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_AllowFrameReordering)
    public static let dataRateLimits: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_DataRateLimits)
    public static let pixelTransferProperties: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_PixelTransferProperties)
    public static let h264EntropyMode: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_H264EntropyMode)
}
