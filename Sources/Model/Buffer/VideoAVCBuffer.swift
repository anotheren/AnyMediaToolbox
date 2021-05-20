//
//  VideoAVCBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/13.
//  Copyright © 2020-2021 anotheren.com. All rights reserved.
//

import AVFoundation

public protocol VideoAVCBuffer: VideoCompressedBuffer {
    
    var sampleBuffer: CMSampleBuffer { get }
    
    init(sampleBuffer: CMSampleBuffer)
}

extension VideoAVCBuffer {
    
    public var formatDescription: CMVideoFormatDescription? {
        return sampleBuffer.formatDescription
    }
    
    public var duration: CMTime {
        return sampleBuffer.duration
    }
    
    public var presentationTimeStamp: CMTime {
        return sampleBuffer.presentationTimeStamp
    }
    
    public var decodeTimeStamp: CMTime {
        return sampleBuffer.decodeTimeStamp
    }
    
    public var videoCoder: VideoCoder {
        return .avc
    }
}

extension VideoAVCBuffer {
    
    public var dependsOnOthers: Bool {
        if let attachments: CFArray = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, createIfNecessary: false) {
            if let attachment = unsafeBitCast(CFArrayGetValueAtIndex(attachments, 0), to: CFDictionary.self) as? [CFString: Any] {
                if let result = attachment[kCMSampleAttachmentKey_DependsOnOthers] as? Bool {
                    return result
                }
            }
        }
        return false
    }
}

extension VideoAVCBuffer {
    
    public init(dataBytes: Data, formatDescription: CMVideoFormatDescription, timingInfo: CMSampleTimingInfo) throws {
        var status: OSStatus = noErr
        
        var blockBufferOut: CMBlockBuffer?
        let length = dataBytes.count
        status = CMBlockBufferCreateWithMemoryBlock(allocator: kCFAllocatorDefault,
                                                    memoryBlock: nil,
                                                    blockLength: length,
                                                    blockAllocator: nil,
                                                    customBlockSource: nil,
                                                    offsetToData: 0,
                                                    dataLength: length,
                                                    flags: 0,
                                                    blockBufferOut: &blockBufferOut)
        guard let blockBuffer = blockBufferOut else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        
        var data = dataBytes
        status = CMBlockBufferReplaceDataBytes(with: &data,
                                               blockBuffer: blockBuffer,
                                               offsetIntoDestination: 0,
                                               dataLength: length)
        guard status == noErr else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        
        var sampleBufferOut: CMSampleBuffer?
        var sampleSizes: [Int] = [length]
        var timingInfo = timingInfo
        status = CMSampleBufferCreate(allocator: kCFAllocatorDefault,
                                      dataBuffer: blockBuffer,
                                      dataReady: true,
                                      makeDataReadyCallback: nil,
                                      refcon: nil,
                                      formatDescription: formatDescription,
                                      sampleCount: 1,
                                      sampleTimingEntryCount: 1,
                                      sampleTimingArray: &timingInfo,
                                      sampleSizeEntryCount: 1,
                                      sampleSizeArray: &sampleSizes,
                                      sampleBufferOut: &sampleBufferOut)
        guard let sampleBuffer = sampleBufferOut else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        
        self.init(sampleBuffer: sampleBuffer)
    }
    
    public func dataBytes() throws -> Data {
        guard let dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        
        var totalLengthOut: Int = 0
        var dataPointerOut: UnsafeMutablePointer<Int8>?
        let status = CMBlockBufferGetDataPointer(dataBuffer, atOffset: 0, lengthAtOffsetOut: nil, totalLengthOut: &totalLengthOut, dataPointerOut: &dataPointerOut)
        guard let buffer = dataPointerOut else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        
        return Data(bytes: buffer, count: totalLengthOut)
    }
}

final public class AnyVideoH264Buffer: VideoAVCBuffer {
    
    public let sampleBuffer: CMSampleBuffer
    
    public init(sampleBuffer: CMSampleBuffer) {
        self.sampleBuffer = sampleBuffer
    }
}

extension AnyVideoH264Buffer: CustomStringConvertible {
    
    public var description: String {
        return "AnyVideoH264Buffer<key=\(!dependsOnOthers),pts=\(presentationTimeStamp.seconds)>"
    }
}
