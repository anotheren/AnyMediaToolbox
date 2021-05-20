//
//  MediaBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/13.
//  Copyright © 2020-2021 anotheren.com. All rights reserved.
//

import AVFoundation

public enum MediaType: Equatable {
    
    case audio
    case video
}

public protocol MediaBuffer {
    
    var mediaType: MediaType { get }
    var formatDescription: CMFormatDescription? { get }
    var duration: CMTime { get }
    var presentationTimeStamp: CMTime { get }
    var decodeTimeStamp: CMTime { get }
}

extension MediaBuffer {
    
    public var timingInfo: CMSampleTimingInfo {
        return CMSampleTimingInfo(duration: duration,
                                  presentationTimeStamp: presentationTimeStamp,
                                  decodeTimeStamp: decodeTimeStamp)
    }
}
