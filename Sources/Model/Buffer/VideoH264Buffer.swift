//
//  VideoH264Buffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/13.
//  Copyright © 2020 anotheren.com. All rights reserved.
//

import AVFoundation

public protocol VideoH264Buffer: VideoCompressedBuffer {
    
    var sampleBuffer: CMSampleBuffer { get }
    
    init(sampleBuffer: CMSampleBuffer)
}

extension VideoH264Buffer {
    
    public var formatDescription: CMFormatDescription? {
        return CMSampleBufferGetFormatDescription(sampleBuffer)
    }
    
    public var duration: CMTime {
        return CMSampleBufferGetDuration(sampleBuffer)
    }
    
    public var presentationTimeStamp: CMTime {
        return CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
    }
    
    public var decodeTimeStamp: CMTime {
        return CMSampleBufferGetDecodeTimeStamp(sampleBuffer)
    }
    
    public var videoCoder: VideoCoder {
        return .avc
    }
}

extension VideoH264Buffer {
    
    public func dataBytes() throws -> Data {
        guard let dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        
        var totalLengthOut: Int = 0
        var dataPointerOut: UnsafeMutablePointer<Int8>?
        let status = CMBlockBufferGetDataPointer(dataBuffer, atOffset: 0, lengthAtOffsetOut: nil, totalLengthOut: &totalLengthOut, dataPointerOut: &dataPointerOut)
        guard let buffer = dataPointerOut else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        
        return Data(bytes: buffer, count: totalLengthOut)
    }
}

final public class AnyVideoH264Buffer: VideoH264Buffer {
    
    public let sampleBuffer: CMSampleBuffer
    
    public init(sampleBuffer: CMSampleBuffer) {
        self.sampleBuffer = sampleBuffer
    }
}
