//
//  ChannelConfiguration.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/23.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation

public enum ChannelConfiguration: UInt8 {
    
    /// Defined in AOT Specifc Config
    case definedInAOTSpecificConfig = 0
    /// 1 channel: front-center
    case frontCenter = 1
    /// 2 channels: front-left, front-right
    case frontLeftAndFrontRight = 2
    /// 3 channels: front-center, front-left, front-right
    case frontCenterAndFrontLeftAndFrontRight = 3
    /// 4 channels: front-center, front-left, front-right, back-center
    case frontCenterAndFrontLeftAndFrontRightAndBackCenter = 4
    /// 5 channels: front-center, front-left, front-right, back-left, back-right
    case frontCenterAndFrontLeftAndFrontRightAndBackLeftAndBackRight = 5
    /// 6 channels: front-center, front-left, front-right, back-left, back-right, LFE-channel
    case frontCenterAndFrontLeftAndFrontRightAndBackLeftAndBackRightLFE = 6
    /// 8 channels: front-center, front-left, front-right, side-left, side-right, back-left, back-right, LFE-channel
    case frontCenterAndFrontLeftAndFrontRightAndSideLeftAndSideRightAndBackLeftAndBackRightLFE = 7
}

extension ChannelConfiguration: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .definedInAOTSpecificConfig:
            return "Defined in AOT Specifc Config"
        case .frontCenter:
            return "1: front-center" //Lc Rc L R Ls Rs Rls Rrs LFE
        case .frontLeftAndFrontRight:
            return "2: front-left, front-right"
        case .frontCenterAndFrontLeftAndFrontRight:
            return "3: front-center, front-left, front-right"
        case .frontCenterAndFrontLeftAndFrontRightAndBackCenter:
            return "4: front-center, front-left, front-right, back-center"
        case .frontCenterAndFrontLeftAndFrontRightAndBackLeftAndBackRight:
            return "5: front-center, front-left, front-right, back-left, back-right"
        case .frontCenterAndFrontLeftAndFrontRightAndBackLeftAndBackRightLFE:
            return "6: front-center, front-left, front-right, back-left, back-right, LFE-channel"
        case .frontCenterAndFrontLeftAndFrontRightAndSideLeftAndSideRightAndBackLeftAndBackRightLFE:
            return "8: front-center, front-left, front-right, side-left, side-right, back-left, back-right, LFE-channel"
        }
    }
}
