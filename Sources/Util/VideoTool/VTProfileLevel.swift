//
//  VTProfileLevel.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/21.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import VideoToolbox

public struct VTProfileLevel: RawRepresentable, Hashable {
    
    public let rawValue: CFString
    
    public init(rawValue: CFString) {
        self.rawValue = rawValue
    }
}

extension VTProfileLevel {
    
    public var isBaseline: Bool {
        return (rawValue as String).contains("Baseline")
    }
}

extension VTProfileLevel {
    
    public static let h264BaselineAutoLevel: VTProfileLevel = .init(rawValue: kVTProfileLevel_H264_Baseline_AutoLevel)
    public static let h264MainAutoLevel: VTProfileLevel = .init(rawValue: kVTProfileLevel_H264_Main_AutoLevel)
    public static let h264HighAutoLevel: VTProfileLevel = .init(rawValue: kVTProfileLevel_H264_High_AutoLevel)
}

// MARK: - CustomStringConvertible
extension VTProfileLevel:CustomStringConvertible {
    
    public var description: String {
        return rawValue as String
    }
}
