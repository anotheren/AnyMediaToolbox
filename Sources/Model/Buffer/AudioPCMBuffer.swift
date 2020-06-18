//
//  AudioPCMBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/16.
//  Copyright © 2020 anotheren.com. All rights reserved.
//

import AVFoundation

public protocol AudioPCMBuffer: AudioRawBuffer {
    
    var buffer: AVAudioPCMBuffer { get }
    var presentationTimeStamp: CMTime { get }
    
    init(buffer: AVAudioPCMBuffer, presentationTimeStamp: CMTime)
}

extension AudioPCMBuffer {
    
    public var format: AVAudioFormat {
        return buffer.format
    }
    
    public var duration: CMTime {
        return CMTime(value: CMTimeValue(buffer.frameLength), timescale: CMTimeScale(format.sampleRate))
    }
    
    public var decodeTimeStamp: CMTime {
        return .invalid
    }
    
    public var audioBufferList: UnsafePointer<AudioBufferList> {
        return buffer.audioBufferList
    }
    
    public var mutableAudioBufferList: UnsafeMutablePointer<AudioBufferList> {
        return buffer.mutableAudioBufferList
    }
    
    public var frameLength: UInt32 {
        return buffer.frameLength
    }
}

extension AudioPCMBuffer {
    
    public init(buffer: AVAudioPCMBuffer, audioTime: AVAudioTime, preferredTimescale: CMTimeScale = 1_000_000_000) {
        let seconds = AVAudioTime.seconds(forHostTime: audioTime.hostTime)
        self.init(buffer: buffer, seconds: seconds, preferredTimescale: preferredTimescale)
    }
    
    public init(buffer: AVAudioPCMBuffer, seconds: Double, preferredTimescale: CMTimeScale = 1_000_000_000) {
        let presentationTimeStamp = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
        self.init(buffer: buffer, presentationTimeStamp: presentationTimeStamp)
    }
}

extension AudioPCMBuffer {
    
    public func dataBytes() -> [Data] {
        var dataBytes: [Data] = []
        for channel in UnsafeMutableAudioBufferListPointer(mutableAudioBufferList) {
            let dataByteSize = Int(channel.mDataByteSize)
            if let mData = channel.mData {
                let data = Data(bytes: mData, count: dataByteSize)
                dataBytes.append(data)
            } else {
                // which means there is no data in this channel, repeating with 0
                let data = Data(repeating: 0, count: dataByteSize)
                dataBytes.append(data)
            }
        }
        return dataBytes
    }
    
    public init(audioBufferList: UnsafeMutablePointer<AudioBufferList>, frameLength: UInt32, streamDescription: AudioStreamBasicDescription, seconds: Double) throws {
        var dataBytes: [Data] = []
        for channel in UnsafeMutableAudioBufferListPointer(audioBufferList) {
            let dataByteSize = Int(channel.mDataByteSize)
            if let mData = channel.mData {
                let data = Data(bytes: mData, count: dataByteSize)
                dataBytes.append(data)
            } else {
                // which means there is no data in this channel, repeating with 0
                let data = Data(repeating: 0, count: dataByteSize)
                dataBytes.append(data)
            }
        }
        try self.init(dataBytes: dataBytes, frameLength: frameLength, streamDescription: streamDescription, seconds: seconds)
    }
    
    public init(dataBytes: [Data], frameLength: UInt32, streamDescription: AudioStreamBasicDescription, seconds: Double) throws {
        var streamDescription = streamDescription
        guard let format = AVAudioFormat(streamDescription: &streamDescription) else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        try self.init(dataBytes: dataBytes, frameLength: frameLength, format: format, seconds: seconds)
    }
    
    public init(dataBytes: [Data], frameLength: UInt32, format: AVAudioFormat, seconds: Double) throws {
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameLength) else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        buffer.frameLength = buffer.frameCapacity
        let frameLength = Int(frameLength)
        let channels = dataBytes.count
        if let channelsPoint = buffer.floatChannelData {
            for channel in 0..<channels {
                let channelPoint = UnsafeMutableBufferPointer(start: channelsPoint[channel], count: frameLength)
                let copyCount = dataBytes[channel].copyBytes(to: channelPoint)
                assert(copyCount == frameLength * MemoryLayout<Float>.size)
            }
        } else if let channelsPoint = buffer.int32ChannelData {
            for channel in 0..<channels {
                let channelPoint = UnsafeMutableBufferPointer(start: channelsPoint[channel], count: frameLength)
                let copyCount = dataBytes[channel].copyBytes(to: channelPoint)
                assert(copyCount == frameLength * MemoryLayout<Int32>.size)
            }
        } else if let channelsPoint = buffer.int16ChannelData {
            for channel in 0..<channels {
                let channelPoint = UnsafeMutableBufferPointer(start: channelsPoint[channel], count: frameLength)
                let copyCount = dataBytes[channel].copyBytes(to: channelPoint)
                assert(copyCount == frameLength * MemoryLayout<Int16>.size)
            }
        }
        self.init(buffer: buffer, seconds: seconds)
    }
}

extension AudioPCMBuffer {
    
    public init(sampleBuffer: CMSampleBuffer) throws {
        guard let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer) else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        let format = AVAudioFormat(cmAudioFormatDescription: formatDescription)
        let numSamples = CMSampleBufferGetNumSamples(sampleBuffer)
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(numSamples)) else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        buffer.frameLength = buffer.frameCapacity
        
        let status = CMSampleBufferCopyPCMDataIntoAudioBufferList(sampleBuffer,
                                                                  at: 0,
                                                                  frameCount: Int32(numSamples),
                                                                  into: buffer.mutableAudioBufferList)
        guard status == noErr else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        
        self.init(buffer: buffer, presentationTimeStamp: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
    }
    
    public func makeSampleBuffer() throws -> CMSampleBuffer {
        let blockBuffer = try makeBlockBuffer(from: mutableAudioBufferList)
        var sampleBufferOut: CMSampleBuffer? = nil
        
        let status = CMAudioSampleBufferCreateReadyWithPacketDescriptions(allocator: kCFAllocatorDefault,
                                                                          dataBuffer: blockBuffer,
                                                                          formatDescription: format.formatDescription,
                                                                          sampleCount: CMItemCount(buffer.frameLength),
                                                                          presentationTimeStamp: presentationTimeStamp,
                                                                          packetDescriptions: nil,
                                                                          sampleBufferOut: &sampleBufferOut)
        guard let sampleBuffer = sampleBufferOut else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        
        return sampleBuffer
    }
    
    private func makeBlockBuffer(from audioListBuffer: UnsafeMutablePointer<AudioBufferList>) throws -> CMBlockBuffer {
        var status: OSStatus = noErr
        var blockListBufferOut: CMBlockBuffer?
        
        status = CMBlockBufferCreateEmpty(allocator: kCFAllocatorDefault,
                                          capacity: 0,
                                          flags: 0,
                                          blockBufferOut: &blockListBufferOut)
        guard status == noErr else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        guard let blockListBuffer = blockListBufferOut else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
        
        for audioBuffer in UnsafeMutableAudioBufferListPointer(audioListBuffer) {
            
            var outBlockBuffer: CMBlockBuffer? = nil
            let dataByteSize = Int(audioBuffer.mDataByteSize)
            
            status = CMBlockBufferCreateWithMemoryBlock(allocator: kCFAllocatorDefault,
                                                        memoryBlock: nil,
                                                        blockLength: dataByteSize,
                                                        blockAllocator: kCFAllocatorDefault,
                                                        customBlockSource: nil,
                                                        offsetToData: 0,
                                                        dataLength: dataByteSize,
                                                        flags: kCMBlockBufferAssureMemoryNowFlag,
                                                        blockBufferOut: &outBlockBuffer)
            
            guard status == noErr else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
            guard let blockBuffer = outBlockBuffer else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
            
            guard let data = audioBuffer.mData else { throw NSError(domain: NSOSStatusErrorDomain, code: -1) }
            status = CMBlockBufferReplaceDataBytes(with: data,
                                                   blockBuffer: blockBuffer,
                                                   offsetIntoDestination: 0,
                                                   dataLength: dataByteSize)
            guard status == noErr else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
            
            status = CMBlockBufferAppendBufferReference(blockListBuffer,
                                                        targetBBuf: blockBuffer,
                                                        offsetToData: 0,
                                                        dataLength: CMBlockBufferGetDataLength(blockBuffer),
                                                        flags: 0)
            guard status == noErr else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
        }
        
        return blockListBuffer
    }
}

final public class AnyAudioPCMBuffer: AudioPCMBuffer {
    
    public let buffer: AVAudioPCMBuffer
    public let presentationTimeStamp: CMTime
    
    public init(buffer: AVAudioPCMBuffer, presentationTimeStamp: CMTime) {
        self.buffer = buffer
        self.presentationTimeStamp = presentationTimeStamp
    }
}
