//
//  AVCEncoder.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/20.
//  Copyright © 2018-2021 anotheren.com. All rights reserved.
//

import CoreMedia
import VideoToolbox

public protocol AVCEncoderDelegate: AnyObject {
    
    func encoder(_ encoder: AVCEncoder, didSet formatDescription: CMVideoFormatDescription?)
    func encoder(_ encoder: AVCEncoder, didOutput buffer: VideoAVCBuffer)
    func encoder(_ encoder: AVCEncoder, didCatch error: Error)
}

final public class AVCEncoder {
    
    public weak var delegate: AVCEncoderDelegate?
    
    private let lockQueue = DispatchQueue(label: "com.anotheren.AnyMediaToolbox.H264Encoder")
    
    private var formatDescription: CMVideoFormatDescription? {
        didSet {
            if formatDescription != oldValue {
                delegate?.encoder(self, didSet: formatDescription)
            }
        }
    }
    
    private var status: OSStatus = noErr {
        didSet {
            if status != noErr {
                let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status))
                delegate?.encoder(self, didCatch: error)
            }
        }
    }
    
    private var invalidateSession = true
    
    public var scalingMode: VTScalingMode = AVCEncoder.Default.scalingMode {
        didSet {
            if scalingMode != oldValue {
                invalidateSession = true
            }
        }
    }
    
    public var width: Int32 = AVCEncoder.Default.width {
        didSet {
            if width != oldValue {
                invalidateSession = true
            }
        }
    }
    
    public var height: Int32 = AVCEncoder.Default.height {
        didSet {
            if height != oldValue {
                invalidateSession = true
            }
        }
    }
    
    #if os(macOS)
    public var enabledHardwareEncoder: Bool = H264Encoder.Default.enabledHardwareEncoder {
        didSet {
            if enabledHardwareEncoder != oldValue {
                invalidateSession = true
            }
        }
    }
    #endif
    
    public var profileLevel: VTProfileLevel = AVCEncoder.Default.profileLevel {
        didSet {
            if profileLevel != oldValue  {
                invalidateSession = true
            }
        }
    }
    
    public var bitrate: UInt32 = AVCEncoder.Default.bitrate {
        didSet {
            if bitrate != oldValue {
                lockQueue.async {
                    guard let session: VTCompressionSession = self._session else { return }
                    self.status = session.setProperty(.averageBitRate, value: self.bitrate as CFTypeRef)
                }
            }
        }
    }
    
    public var expectedFrameRate: Double = AVCEncoder.Default.expectedFrameRate {
        didSet {
            if expectedFrameRate != oldValue {
                lockQueue.async {
                    guard let session: VTCompressionSession = self._session else { return }
                    self.status = session.setProperty(.expectedFrameRate, value: self.expectedFrameRate as CFTypeRef)
                }
            }
        }
    }
    
    public var maxKeyFrameIntervalDuration: Double = AVCEncoder.Default.maxKeyFrameIntervalDuration  {
        didSet {
            if maxKeyFrameIntervalDuration != oldValue {
                lockQueue.async {
                    guard let session: VTCompressionSession = self._session else { return }
                    self.status = session.setProperty(.maxKeyFrameIntervalDuration, value: self.maxKeyFrameIntervalDuration as CFTypeRef)
                }
            }
        }
    }
    
    public var dataRateLimits: [Int] = AVCEncoder.Default.dataRateLimits {
        didSet {
            if dataRateLimits != oldValue, dataRateLimits != AVCEncoder.Default.dataRateLimits {
                lockQueue.async {
                    guard let session: VTCompressionSession = self._session else { return }
                    self.status = session.setProperty(.dataRateLimits, value: self.dataRateLimits as CFTypeRef)
                }
            }
        }
    }
    
    private var sourceImageBufferAttributes: [CFString: CFTypeRef] {
        var attributes = AVCEncoder.Default.attributes
        attributes[kCVPixelBufferWidthKey] = width as CFTypeRef
        attributes[kCVPixelBufferHeightKey] = height as CFTypeRef
        return attributes
    }
    
    private var callback: VTCompressionOutputCallback = { (outputCallbackRefCon: UnsafeMutableRawPointer?, sourceFrameRefCon: UnsafeMutableRawPointer?, status: OSStatus, infoFlags: VTEncodeInfoFlags, sampleBuffer: CMSampleBuffer?) in
        guard let sampleBuffer: CMSampleBuffer = sampleBuffer, let refCon = outputCallbackRefCon, status == noErr else { return }
        let encoder = Unmanaged<AVCEncoder>.fromOpaque(refCon).takeUnretainedValue()
        encoder.formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
        let buffer = AnyVideoH264Buffer(sampleBuffer: sampleBuffer)
        encoder.delegate?.encoder(encoder, didOutput: buffer)
    }
    
    private var properties: [VTCompressionPropertyKey: CFTypeRef] {
        let isBaseline = profileLevel.isBaseline
        var properties: [VTCompressionPropertyKey: CFTypeRef] = [
            .realTime: kCFBooleanTrue,
            .profileLevel: profileLevel.rawValue,
            .averageBitRate: bitrate as CFTypeRef,
            .expectedFrameRate: expectedFrameRate as CFTypeRef,
            .maxKeyFrameIntervalDuration: maxKeyFrameIntervalDuration as CFTypeRef,
            .allowFrameReordering: (!isBaseline).cfBoolean,
            .dataRateLimits: dataRateLimits as CFTypeRef,
            .pixelTransferProperties: [
                kVTPixelTransferPropertyKey_ScalingMode: scalingMode.rawValue,
                ] as CFDictionary,
        ]
        
        #if os(macOS)
        if enabledHardwareEncoder {
            properties[.encoderID] = "com.apple.videotoolbox.videoencoder.h264.gva" as CFString
            properties[.enableHardwareAcceleratedVideoEncoder] = kCFBooleanTrue
            properties[.requireHardwareAcceleratedVideoEncoder] = kCFBooleanTrue
        }
        #endif
        
        if dataRateLimits != AVCEncoder.Default.dataRateLimits {
            properties[.dataRateLimits] = dataRateLimits as CFTypeRef
        }
        
        if !isBaseline {
            properties[.h264EntropyMode] = kVTH264EntropyMode_CABAC
        }
        
        return properties
    }
    
    private var _session: VTCompressionSession?
    private var session: VTCompressionSession? {
        get {
            if _session == nil {
                status = VTCompressionSessionCreate(allocator: kCFAllocatorDefault,
                                                    width: width,
                                                    height: height,
                                                    codecType: kCMVideoCodecType_H264,
                                                    encoderSpecification: nil,
                                                    imageBufferAttributes: sourceImageBufferAttributes as CFDictionary,
                                                    compressedDataAllocator: nil,
                                                    outputCallback: callback,
                                                    refcon: Unmanaged.passUnretained(self).toOpaque(),
                                                    compressionSessionOut: &_session)
                guard status == noErr, let session = _session else { return nil }
                invalidateSession = false
                status = session.setProperties(properties)
                status = session.prepareToEncodeFrames()
            }
            return _session
        }
        set {
            if let session: VTCompressionSession = _session {
                session.invalidate()
            }
            _session = newValue
        }
    }
    
    public private(set) var running: Bool = false
    
    public init() { }
    
    public func encode(buffer: VideoPixelBuffer) {
        guard running else { return }
        if invalidateSession { session = nil }
        guard let session = self.session else { return }
        var infoFlags = VTEncodeInfoFlags()
        status = VTCompressionSessionEncodeFrame(session,
                                                 imageBuffer: buffer.pixelBuffer,
                                                 presentationTimeStamp: buffer.presentationTimeStamp,
                                                 duration: buffer.duration,
                                                 frameProperties: nil,
                                                 sourceFrameRefcon: nil,
                                                 infoFlagsOut: &infoFlags)
    }
    
    public func startRunning() {
        lockQueue.async {
            self.running = true
        }
    }
    
    public func stopRunning() {
        lockQueue.async {
            self.session = nil
            self.formatDescription = nil
            self.running = false
        }
    }
}

extension AVCEncoder {
    
    private struct Default {
        
        static let width: Int32 = 1920
        static let height: Int32 = 1080
        static let bitrate: UInt32 = 2000 * 1024
        static let scalingMode: VTScalingMode = .trim
        static let dataRateLimits: [Int] = [3000 * 1024 / 8, 1]
        static let profileLevel: VTProfileLevel = .h264MainAutoLevel
        static let expectedFrameRate: Double = 30
        static let maxKeyFrameIntervalDuration: Double = 2
        
        #if os(iOS) || os(tvOS)
        static let attributes: [CFString: CFTypeRef] = [
                kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
                kCVPixelBufferOpenGLESCompatibilityKey: kCFBooleanTrue,
                kCVPixelBufferMetalCompatibilityKey: kCFBooleanTrue,
            ]
        #elseif os(macOS)
        static let attributes: [CFString: CFTypeRef] = [
                kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
                kCVPixelBufferOpenGLCompatibilityKey: kCFBooleanTrue,
            ]
        
        static let enabledHardwareEncoder: Bool = true
        #endif
    }
}
