//
//  VideoBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/13.
//  Copyright © 2020 anotheren.com. All rights reserved.
//

import AVFoundation

public protocol VideoBuffer: MediaBuffer {
    
}

extension VideoBuffer {
    
    public var mediaType: MediaType {
        return .video
    }
}

public protocol VideoRawBuffer: VideoBuffer {
    
}

public protocol VideoCompressedBuffer: VideoBuffer {
    
    var videoCoder: VideoCoder { get }
    
    func dataBytes() throws -> Data
}

public enum VideoCoder: Equatable {
    
    case avc
    case hevc
}
