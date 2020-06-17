//
//  AudioAACBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/16.
//  Copyright © 2020 anotheren.com. All rights reserved.
//

import AVFoundation

public protocol AudioAACBuffer: AudioCompressedBuffer {
    
    var buffer: AVAudioCompressedBuffer { get }
    var presentationTimeStamp: CMTime { get }
    
    init(buffer: AVAudioCompressedBuffer, presentationTimeStamp: CMTime)
}

extension AudioAACBuffer {
    
    public var format: AVAudioFormat {
        return buffer.format
    }
    
    public var duration: CMTime {
        return CMTime(value: 1024, timescale: CMTimeScale(format.sampleRate))
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
    
    public var audioCoder: AudioCoder {
        return .aac
    }
}

extension AudioAACBuffer {
    
    public init(buffer: AVAudioCompressedBuffer, audioTime: AVAudioTime, preferredTimescale: CMTimeScale = 1_000_000_000) {
        let seconds = AVAudioTime.seconds(forHostTime: audioTime.hostTime)
        self.init(buffer: buffer, seconds: seconds, preferredTimescale: preferredTimescale)
    }
    
    public init(buffer: AVAudioCompressedBuffer, seconds: Double, preferredTimescale: CMTimeScale = 1_000_000_000) {
        let presentationTimeStamp = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
        self.init(buffer: buffer, presentationTimeStamp: presentationTimeStamp)
    }
}

extension AudioAACBuffer {
    
    public func dataBytes() throws -> Data {
        let audioBufferListPointer = UnsafeMutableAudioBufferListPointer(buffer.mutableAudioBufferList)
        guard let first = audioBufferListPointer.first, let data = first.mData else {
            throw NSError(domain: NSOSStatusErrorDomain, code: -1)
        }
        return Data(bytes: data, count: Int(first.mDataByteSize))
    }
}

final public class AnyAudioAACBuffer: AudioAACBuffer {
    
    public let buffer: AVAudioCompressedBuffer
    public let presentationTimeStamp: CMTime
    
    public init(buffer: AVAudioCompressedBuffer, presentationTimeStamp: CMTime) {
        self.buffer = buffer
        self.presentationTimeStamp = presentationTimeStamp
    }
}
