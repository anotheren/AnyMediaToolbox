//
//  VideoBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/13.
//  Copyright © 2020-2021 anotheren.com. All rights reserved.
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

public struct VideoCoder: RawRepresentable, Equatable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension VideoCoder: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
}

extension VideoCoder {
    
    public static let avc: VideoCoder = .init(rawValue: "AAC")
    
    public static let hevc: VideoCoder = .init(rawValue: "HEVC")
}
