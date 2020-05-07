//
//  VideoEncoder.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/20.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation
import CoreMedia

public protocol VideoEncoder: class {
    
    var delegate: VideoEncoderDelegate? { get set }
    
    var muted: Bool { get set }
    
    var running: Bool { get }
    func startRunning()
    func stopRunning()
    
    func encode(imageBuffer: CVImageBuffer, presentationTimeStamp: CMTime, duration: CMTime)
}

public protocol VideoEncoderDelegate: class {
    
    func videoEncoder(_ encoder: VideoEncoder, didSet formatDescription: CMVideoFormatDescription?)
    func videoEncoder(_ encoder: VideoEncoder, didOutput sampleBuffer: CMSampleBuffer)
    func videoEncoder(_ encoder: VideoEncoder, didCatch error: VideoEncoderError)
}

public enum VideoEncoderError: Error {
    
    case vtEncoderError(OSStatus)
}
