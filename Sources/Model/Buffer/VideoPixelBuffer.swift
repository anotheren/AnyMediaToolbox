//
//  VideoPixelBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/13.
//  Copyright © 2020 anotheren.com. All rights reserved.
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
        var formatDescriptionOut: CMVideoFormatDescription?
        let status = CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                                  imageBuffer: pixelBuffer,
                                                                  formatDescriptionOut: &formatDescriptionOut)
        guard let formatDescription = formatDescriptionOut else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
        return formatDescription
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
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        let presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let duration = CMSampleBufferGetDuration(sampleBuffer)
        self.init(pixelBuffer: pixelBuffer, presentationTimeStamp: presentationTimeStamp, duration: duration)
    }
    
    public func makeSampleBuffer() throws -> CMSampleBuffer {
        let formatDescription = try makeFormatDescription()
        var sampleBufferOut: CMSampleBuffer?
        var sampleTiming = timingInfo
        
        let status = CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault,
                                                              imageBuffer: pixelBuffer,
                                                              formatDescription: formatDescription,
                                                              sampleTiming: &sampleTiming,
                                                              sampleBufferOut: &sampleBufferOut)
        
        guard let sampleBuffer = sampleBufferOut else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        return sampleBuffer
    }
}

final public class AnyVideoPixelBuffer: VideoPixelBuffer {
    
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
