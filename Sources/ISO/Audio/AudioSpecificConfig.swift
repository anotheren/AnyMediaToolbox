//
//  AudioSpecificConfig.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/23.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation
import CoreAudioTypes

public struct AudioSpecificConfig {
    
    public let type: AudioObjectType
    public let frequency: SamplingFrequency
    public let channel: ChannelConfiguration
    
    public var data: Data {
        var buffer = Data(repeating: 0, count: 2)
        buffer[0] = type.rawValue << 3 | (frequency.rawValue >> 1 & 0x3)
        buffer[1] = (frequency.rawValue & 0x1) << 7 | (channel.rawValue & 0xF) << 3
        return buffer
    }
    
    public var streamBasicDescription: AudioStreamBasicDescription {
        var asbd: AudioStreamBasicDescription = AudioStreamBasicDescription()
        asbd.mSampleRate = frequency.sampleRate
        asbd.mFormatID = kAudioFormatMPEG4AAC
        asbd.mFormatFlags = UInt32(type.rawValue)
        asbd.mBytesPerPacket = 0
        asbd.mFramesPerPacket = 1024
        asbd.mBytesPerFrame = 0
        asbd.mChannelsPerFrame = UInt32(channel.rawValue)
        asbd.mBitsPerChannel = 0
        asbd.mReserved = 0
        return asbd
    }
    
    public init(type: AudioObjectType, frequency: SamplingFrequency, channel: ChannelConfiguration) {
        self.type = type
        self.frequency = frequency
        self.channel = channel
    }
    
    public init?(data: Data) {
        guard let type = AudioObjectType(rawValue: data[0] >> 3) else { return  nil }
        guard let frequency = SamplingFrequency(rawValue: (data[0] & 0b00000111) << 1 | (data[1] >> 7)) else { return nil }
        guard let channel = ChannelConfiguration(rawValue: (data[1] & 0b01111000) >> 3) else { return nil }
        self.init(type: type, frequency: frequency, channel: channel)
    }
    
    public func adts(_ length: Int) -> Data {
        let size: Int = 7
        let fullSize: Int = size + length
        var adts = Data(repeating: 0x00, count: size)
        adts[0] = 0xFF
        adts[1] = 0xF9
        adts[2] = (type.rawValue - 1) << 6 | (frequency.rawValue << 2) | (channel.rawValue >> 2)
        adts[3] = (channel.rawValue & 3) << 6 | UInt8(fullSize >> 11)
        adts[4] = UInt8((fullSize & 0x7FF) >> 3)
        adts[5] = ((UInt8(fullSize & 7)) << 5) + 0x1F
        adts[6] = 0xFC
        return adts
    }
}
