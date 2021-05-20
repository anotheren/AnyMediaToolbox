//
//  AudioBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/16.
//  Copyright © 2020-2021 anotheren.com. All rights reserved.
//

import AVFoundation

public protocol AudioBuffer: MediaBuffer {
    
    var format: AVAudioFormat { get }
    var streamDescription: AudioStreamBasicDescription { get }
    var audioBufferList: UnsafePointer<AudioBufferList> { get }
    var mutableAudioBufferList: UnsafeMutablePointer<AudioBufferList> { get }
}

extension AudioBuffer {
    
    public var mediaType: MediaType {
        return .audio
    }
    
    public var streamDescription: AudioStreamBasicDescription {
        return format.streamDescription.pointee
    }
    
    public var formatDescription: CMAudioFormatDescription? {
        return format.formatDescription
    }
}

public protocol AudioRawBuffer: AudioBuffer {
    
}

public protocol AudioCompressedBuffer: AudioBuffer {
    
    var audioCoder: AudioCoder { get }
    
    func dataBytes() throws -> Data
}

public enum AudioCoder: Equatable {
    
    case aac
}
