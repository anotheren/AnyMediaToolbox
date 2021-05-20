//
//  AudioSpecificConfig.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/23.
//  Copyright © 2018-2021 anotheren.com. All rights reserved.
//

import AVFoundation

public struct AudioSpecificConfig {
    
    public let type: AudioObjectType
    public let frequency: SamplingFrequency
    public let channel: ChannelConfiguration
    
    public init(type: AudioObjectType, frequency: SamplingFrequency, channel: ChannelConfiguration) {
        self.type = type
        self.frequency = frequency
        self.channel = channel
    }
}

extension AudioSpecificConfig {
    
    public init?(data: Data) {
        guard data.count >= 2 else { return nil }
        guard let type = AudioObjectType(rawValue: data[0] >> 3) else { return  nil }
        guard let frequency = SamplingFrequency(rawValue: (data[0] & 0b00000111) << 1 | (data[1] >> 7)) else { return nil }
        guard let channel = ChannelConfiguration(rawValue: (data[1] & 0b01111000) >> 3) else { return nil }
        self.init(type: type, frequency: frequency, channel: channel)
    }
    
    public func dataBytes() -> Data {
        var buffer = Data(repeating: 0, count: 2)
        buffer[0] = type.rawValue << 3 | (frequency.rawValue >> 1 & 0x3)
        buffer[1] = (frequency.rawValue & 0x1) << 7 | (channel.rawValue & 0xF) << 3
        return buffer
    }
}

extension AudioSpecificConfig {
    
    public var audioStreamBasicDescription: AudioStreamBasicDescription {
        return AudioStreamBasicDescription(mSampleRate: frequency.sampleRate,
                                           mFormatID: kAudioFormatMPEG4AAC,
                                           mFormatFlags: UInt32(type.rawValue),
                                           mBytesPerPacket: 0,
                                           mFramesPerPacket: 1024,
                                           mBytesPerFrame: 0,
                                           mChannelsPerFrame: UInt32(channel.rawValue),
                                           mBitsPerChannel: 0,
                                           mReserved: 0)
    }
    
    public func makeFormatDescription() throws -> CMAudioFormatDescription {
        var formatDescriptionOut: CMAudioFormatDescription?
        var audioStreamBasicDescription = self.audioStreamBasicDescription
        let status = CMAudioFormatDescriptionCreate(allocator: kCFAllocatorDefault,
                                                    asbd: &audioStreamBasicDescription,
                                                    layoutSize: 0,
                                                    layout: nil,
                                                    magicCookieSize: 0,
                                                    magicCookie: nil,
                                                    extensions: nil,
                                                    formatDescriptionOut: &formatDescriptionOut)
        guard let formatDescription = formatDescriptionOut else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
        return formatDescription
    }
}
