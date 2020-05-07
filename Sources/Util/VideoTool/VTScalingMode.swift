//
//  VTScalingMode.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/21.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import VideoToolbox

public struct VTScalingMode: RawRepresentable, Hashable {
    
    public let rawValue: CFString
    
    public init(rawValue: CFString) {
        self.rawValue = rawValue
    }
}

extension VTScalingMode {
    
    /// Copy full width and height.  Write adjusted clean aperture and pixel aspect ratios to compensate for any change in dimensions.
    public static let normal: VTScalingMode = .init(rawValue: kVTScalingMode_Normal)
    
    /// Crop to remove edge processing region; scale remainder to destination clean aperture.
    public static let cropSourceToCleanAperture: VTScalingMode = .init(rawValue: kVTScalingMode_CropSourceToCleanAperture)
    
    /// Preserve aspect ratio of the source, and fill remaining areas with black in to fit destination dimensions
    public static let letterbox: VTScalingMode = .init(rawValue: kVTScalingMode_Letterbox)
    
    /// Preserve aspect ratio of the source, and crop picture to fit destination dimensions
    public static let trim: VTScalingMode = .init(rawValue: kVTScalingMode_Trim)
}

// MARK: - CustomStringConvertible
extension VTScalingMode: CustomStringConvertible {
    
    public var description: String {
        return rawValue as String
    }
}
