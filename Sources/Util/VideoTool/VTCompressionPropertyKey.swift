//
//  VTCompressionPropertyKey.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/21.
//  Copyright © 2018-2021 anotheren.com. All rights reserved.
//

import VideoToolbox

struct VTCompressionPropertyKey: RawRepresentable, Hashable {
    
    public let rawValue: CFString
    
    public init(rawValue: CFString) {
        self.rawValue = rawValue
    }
}

extension VTCompressionPropertyKey {
    
    /// Hints the video encoder that compression is, or is not, being performed in real time.
    public static let realTime: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_RealTime)
    
    /// Specifies the profile and level for the encoded bitstream.
    public static let profileLevel: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_ProfileLevel)
    
    /// The long-term desired average bit rate in bits per second.
    public static let averageBitRate: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_AverageBitRate)
    
    /// Indicates the expected frame rate, if known.
    public static let expectedFrameRate: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_ExpectedFrameRate)
    
    /// The maximum duration from one key frame to the next in seconds.
    public static let maxKeyFrameIntervalDuration: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration)
    
    /// Enables frame reordering.
    public static let allowFrameReordering: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_AllowFrameReordering)
    
    /// Zero, one or two hard limits on data rate.
    public static let dataRateLimits: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_DataRateLimits)
    
    /// Specifies properties to configure a VTPixelTransferSession used to transfer source frames from the client's image buffers to the video encoder's image buffers, if necessary.
    public static let pixelTransferProperties: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_PixelTransferProperties)
    
    /// The entropy encoding mode for H.264 compression.
    public static let h264EntropyMode: VTCompressionPropertyKey = .init(rawValue: kVTCompressionPropertyKey_H264EntropyMode)
}
