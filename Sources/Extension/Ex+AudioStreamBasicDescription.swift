//
//  Ex+AudioStreamBasicDescription.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/23.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import CoreAudio

extension AudioStreamBasicDescription {
    
    public var audioSpecificConfig: AudioSpecificConfig? {
        guard let objectID = MPEG4ObjectID(rawValue: Int(mFormatFlags)) else { return nil }
        let type = AudioObjectType(objectID: objectID)
        let frequency = SamplingFrequency(sampleRate: mSampleRate)
        guard let channel = ChannelConfiguration(rawValue: UInt8(mChannelsPerFrame)) else { return nil }
        let audioSpecificConfig = AudioSpecificConfig(type: type, frequency: frequency, channel: channel)
        return audioSpecificConfig
    }
}
