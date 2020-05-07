//
//  AudioObjectType.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/23.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation
import CoreAudio

public enum AudioObjectType: UInt8 {
    
    case unknown     = 0
    case aacMain     = 1
    case aacLC       = 2
    case aacSSR      = 3
    case aacLTP      = 4
    case aacSBR      = 5
    case aacScalable = 6
    case twinVQ      = 7
    case celp        = 8
    case hxvc        = 9
    
    public init(objectID: MPEG4ObjectID) {
        switch objectID {
        case .aac_Main:
            self = .aacMain
        case .AAC_LC:
            self = .aacLC
        case .AAC_SSR:
            self = .aacSSR
        case .AAC_LTP:
            self = .aacLTP
        case .AAC_SBR:
            self = .aacSBR
        case .aac_Scalable:
            self = .aacScalable
        case .twinVQ:
            self = .twinVQ
        case .CELP:
            self = .celp
        case .HVXC:
            self = .hxvc
        @unknown default:
            self = .unknown
        }
    }
}

extension AudioObjectType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .unknown:
            return "unknow"
        case .aacMain:
            return "AAC_Main"
        case .aacLC:
            return "AAC_LC"
        case .aacSSR:
            return "AAC_SSR"
        case .aacLTP:
            return "AAC_LTP"
        case .aacSBR:
            return "AAC_SBR"
        case .aacScalable:
            return "AAC_Scalable"
        case .twinVQ:
            return "twinVQ"
        case .celp:
            return "CELP"
        case .hxvc:
            return "HVXC"
        }
    }
}
