//
//  VideoPixelBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/13.
//  Copyright © 2020-2021 anotheren.com. All rights reserved.
//

import AVFoundation

public protocol VideoPixelBuffer: VideoRawBuffer {
    
    var pixelBuffer: CVPixelBuffer { get }
    
    init(pixelBuffer: CVPixelBuffer, presentationTimeStamp: CMTime, duration: CMTime)
}

extension VideoPixelBuffer {
    
    public var decodeTimeStamp: CMTime {
        return .invalid
    }
    
    public var formatDescription: CMVideoFormatDescription? {
        return try? makeFormatDescription()
    }
    
    public func makeFormatDescription() throws -> CMVideoFormatDescription {
        return try CMVideoFormatDescription(imageBuffer: pixelBuffer)
    }
}

extension VideoPixelBuffer {
    
    public var pixelFormatType: OSType {
        return CVPixelBufferGetPixelFormatType(pixelBuffer)
    }
    
    public var width: Int {
        return CVPixelBufferGetWidth(pixelBuffer)
    }
    
    public var height: Int {
        return CVPixelBufferGetHeight(pixelBuffer)
    }
}

extension VideoPixelBuffer {
    
    public init(sampleBuffer: CMSampleBuffer) throws {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        self.init(pixelBuffer: pixelBuffer, presentationTimeStamp: sampleBuffer.presentationTimeStamp, duration: sampleBuffer.duration)
    }
    
    public func makeSampleBuffer() throws -> CMSampleBuffer {
        let formatDescription = try makeFormatDescription()
        return try CMSampleBuffer(imageBuffer: pixelBuffer, formatDescription: formatDescription, sampleTiming: timingInfo)
    }
}

public struct AnyVideoPixelBuffer: VideoPixelBuffer {
    
    public let pixelBuffer: CVPixelBuffer
    public let presentationTimeStamp: CMTime
    public let duration: CMTime
    
    public init(pixelBuffer: CVPixelBuffer, presentationTimeStamp: CMTime, duration: CMTime) {
        self.pixelBuffer = pixelBuffer
        self.presentationTimeStamp = presentationTimeStamp
        self.duration = duration
    }
}

extension AnyVideoPixelBuffer: CustomStringConvertible {
    
    public var description: String {
        return "AnyVideoPixelBuffer<w=\(width),h=\(height),pts=\(presentationTimeStamp.seconds)>"
    }
}
