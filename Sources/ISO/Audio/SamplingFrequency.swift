//
//  SamplingFrequency.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/23.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation

public enum SamplingFrequency: UInt8 {
    
    case hz96000 = 0
    case hz88200 = 1
    case hz64000 = 2
    case hz48000 = 3
    case hz44100 = 4
    case hz32000 = 5
    case hz24000 = 6
    case hz22050 = 7
    case hz16000 = 8
    case hz12000 = 9
    case hz11025 = 10
    case hz8000  = 11
    case hz7350  = 12
    
    public var sampleRate: Float64 {
        switch self {
        case .hz96000:
            return 96000
        case .hz88200:
            return 88200
        case .hz64000:
            return 64000
        case .hz48000:
            return 48000
        case .hz44100:
            return 44100
        case .hz32000:
            return 32000
        case .hz24000:
            return 24000
        case .hz22050:
            return 22050
        case .hz16000:
            return 16000
        case .hz12000:
            return 12000
        case .hz11025:
            return 11025
        case .hz8000:
            return 8000
        case .hz7350:
            return 7350
        }
    }
    
    public init(sampleRate: Float64) {
        switch sampleRate {
        case 96000:
            self = .hz96000
        case 88200:
            self = .hz88200
        case 64000:
            self = .hz64000
        case 48000:
            self = .hz48000
        case 44100:
            self = .hz44100
        case 32000:
            self = .hz32000
        case 24000:
            self = .hz24000
        case 22050:
            self = .hz22050
        case 16000:
            self = .hz16000
        case 12000:
            self = .hz12000
        case 11025:
            self = .hz11025
        case 8000:
            self = .hz8000
        case 7350:
            self = .hz7350
        default:
            self = .hz44100
        }
    }
}

extension SamplingFrequency: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .hz96000:
            return "hz96000"
        case .hz88200:
            return "hz88200"
        case .hz64000:
            return "hz64000"
        case .hz48000:
            return "hz48000"
        case .hz44100:
            return "hz44100"
        case .hz32000:
            return "hz32000"
        case .hz24000:
            return "hz24000"
        case .hz22050:
            return "hz22050"
        case .hz16000:
            return "hz16000"
        case .hz12000:
            return "hz12000"
        case .hz11025:
            return "hz11025"
        case .hz8000:
            return "hz8000"
        case .hz7350:
            return "hz7350"
        }
    }
}
