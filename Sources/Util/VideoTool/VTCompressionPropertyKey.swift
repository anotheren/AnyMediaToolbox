//
//  VTCompressionPropertyKey.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/21.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import VideoToolbox

enum VTCompressionPropertyKey: RawRepresentable, Equatable, Hashable {
    
    case numberOfPendingFrames
    case pixelBufferPoolIsShared
    case videoEncoderPixelBufferAttributes
    case maxKeyFrameInterval
    case maxKeyFrameIntervalDuration
    case allowTemporalCompression
    case allowFrameReordering
    case averageBitRate
    case dataRateLimits
    case quality
    case moreFramesBeforeStart
    case moreFramesAfterEnd
    case profileLevel
    case h264EntropyMode
    case depth
    case maxFrameDelayCount
    case maxH264SliceBytes
    case realTime
    case sourceFrameCount
    case expectedFrameRate
    case expectedDuration
    case baseLayerFrameRate
    
    #if os(macOS)
    case enableHardwareAcceleratedVideoEncoder
    case requireHardwareAcceleratedVideoEncoder
    case usingHardwareAcceleratedVideoEncoder
    case forceKeyFrame
    #endif
    
    case cleanAperture
    case pixelAspectRatio
    case fieldCount
    case fieldDetail
    case aspectRatio16x9
    case progressiveScan
    case colorPrimaries
    case transferFunction
    case yCbCrMatrix
    case iCCProfile
    case masteringDisplayColorVolume
    case contentLightLevelInfo
    case pixelTransferProperties
    case multiPassStorage
    case encoderID
    
    #if os(iOS) || os(tvOS)
    init?(rawValue: CFString) {
        switch rawValue {
        case kVTCompressionPropertyKey_NumberOfPendingFrames:
            self = .numberOfPendingFrames
        case kVTCompressionPropertyKey_PixelBufferPoolIsShared:
            self = .pixelBufferPoolIsShared
        case kVTCompressionPropertyKey_VideoEncoderPixelBufferAttributes:
            self = .videoEncoderPixelBufferAttributes
        case kVTCompressionPropertyKey_MaxKeyFrameInterval:
            self = .maxKeyFrameInterval
        case kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration:
            self = .maxKeyFrameIntervalDuration
        case kVTCompressionPropertyKey_AllowTemporalCompression:
            self = .allowTemporalCompression
        case kVTCompressionPropertyKey_AllowFrameReordering:
            self = .allowFrameReordering
        case kVTCompressionPropertyKey_AverageBitRate:
            self = .averageBitRate
        case kVTCompressionPropertyKey_DataRateLimits:
            self = .dataRateLimits
        case kVTCompressionPropertyKey_Quality:
            self = .quality
        case kVTCompressionPropertyKey_MoreFramesBeforeStart:
            self = .moreFramesBeforeStart
        case kVTCompressionPropertyKey_MoreFramesAfterEnd:
            self = .moreFramesAfterEnd
        case kVTCompressionPropertyKey_ProfileLevel:
            self = .profileLevel
        case kVTCompressionPropertyKey_H264EntropyMode:
            self = .h264EntropyMode
        case kVTCompressionPropertyKey_Depth:
            self = .depth
        case kVTCompressionPropertyKey_MaxFrameDelayCount:
            self = .maxFrameDelayCount
        case kVTCompressionPropertyKey_MaxH264SliceBytes:
            self = .maxH264SliceBytes
        case kVTCompressionPropertyKey_RealTime:
            self = .realTime
        case kVTCompressionPropertyKey_SourceFrameCount:
            self = .sourceFrameCount
        case kVTCompressionPropertyKey_ExpectedFrameRate:
            self = .expectedFrameRate
        case kVTCompressionPropertyKey_ExpectedDuration:
            self = .expectedDuration
        case kVTCompressionPropertyKey_BaseLayerFrameRate:
            self = .baseLayerFrameRate
        case kVTCompressionPropertyKey_CleanAperture:
            self = .cleanAperture
        case kVTCompressionPropertyKey_PixelAspectRatio:
            self = .pixelAspectRatio
        case kVTCompressionPropertyKey_FieldCount:
            self = .fieldCount
        case kVTCompressionPropertyKey_FieldDetail:
            self = .fieldDetail
        case kVTCompressionPropertyKey_AspectRatio16x9:
            self = .aspectRatio16x9
        case kVTCompressionPropertyKey_ProgressiveScan:
            self = .progressiveScan
        case kVTCompressionPropertyKey_ColorPrimaries:
            self = .colorPrimaries
        case kVTCompressionPropertyKey_TransferFunction:
            self = .transferFunction
        case kVTCompressionPropertyKey_YCbCrMatrix:
            self = .yCbCrMatrix
        case kVTCompressionPropertyKey_ICCProfile:
            self = .iCCProfile
        case kVTCompressionPropertyKey_MasteringDisplayColorVolume:
            self = .masteringDisplayColorVolume
        case kVTCompressionPropertyKey_ContentLightLevelInfo:
            self = .contentLightLevelInfo
        case kVTCompressionPropertyKey_PixelTransferProperties:
            self = .pixelTransferProperties
        case kVTCompressionPropertyKey_MultiPassStorage:
            self = .multiPassStorage
        case kVTCompressionPropertyKey_EncoderID:
            self = .encoderID
        default:
            return nil
        }
    }
    #elseif os(macOS)
    init?(rawValue: CFString) {
        switch rawValue {
        case kVTCompressionPropertyKey_NumberOfPendingFrames:
            self = .numberOfPendingFrames
        case kVTCompressionPropertyKey_PixelBufferPoolIsShared:
            self = .pixelBufferPoolIsShared
        case kVTCompressionPropertyKey_VideoEncoderPixelBufferAttributes:
            self = .videoEncoderPixelBufferAttributes
        case kVTCompressionPropertyKey_MaxKeyFrameInterval:
            self = .maxKeyFrameInterval
        case kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration:
            self = .maxKeyFrameIntervalDuration
        case kVTCompressionPropertyKey_AllowTemporalCompression:
            self = .allowTemporalCompression
        case kVTCompressionPropertyKey_AllowFrameReordering:
            self = .allowFrameReordering
        case kVTCompressionPropertyKey_AverageBitRate:
            self = .averageBitRate
        case kVTCompressionPropertyKey_DataRateLimits:
            self = .dataRateLimits
        case kVTCompressionPropertyKey_Quality:
            self = .quality
        case kVTCompressionPropertyKey_MoreFramesBeforeStart:
            self = .moreFramesBeforeStart
        case kVTCompressionPropertyKey_MoreFramesAfterEnd:
            self = .moreFramesAfterEnd
        case kVTCompressionPropertyKey_ProfileLevel:
            self = .profileLevel
        case kVTCompressionPropertyKey_H264EntropyMode:
            self = .h264EntropyMode
        case kVTCompressionPropertyKey_Depth:
            self = .depth
        case kVTCompressionPropertyKey_MaxFrameDelayCount:
            self = .maxFrameDelayCount
        case kVTCompressionPropertyKey_MaxH264SliceBytes:
            self = .maxH264SliceBytes
        case kVTCompressionPropertyKey_RealTime:
            self = .realTime
        case kVTCompressionPropertyKey_SourceFrameCount:
            self = .sourceFrameCount
        case kVTCompressionPropertyKey_ExpectedFrameRate:
            self = .expectedFrameRate
        case kVTCompressionPropertyKey_ExpectedDuration:
            self = .expectedDuration
        case kVTCompressionPropertyKey_BaseLayerFrameRate:
            self = .baseLayerFrameRate
        case kVTVideoEncoderSpecification_EnableHardwareAcceleratedVideoEncoder:
            self = .enableHardwareAcceleratedVideoEncoder
        case kVTVideoEncoderSpecification_RequireHardwareAcceleratedVideoEncoder:
            self = .requireHardwareAcceleratedVideoEncoder
        case kVTCompressionPropertyKey_UsingHardwareAcceleratedVideoEncoder:
            self = .usingHardwareAcceleratedVideoEncoder
        case kVTEncodeFrameOptionKey_ForceKeyFrame:
            self = .forceKeyFrame
        case kVTCompressionPropertyKey_CleanAperture:
            self = .cleanAperture
        case kVTCompressionPropertyKey_PixelAspectRatio:
            self = .pixelAspectRatio
        case kVTCompressionPropertyKey_FieldCount:
            self = .fieldCount
        case kVTCompressionPropertyKey_FieldDetail:
            self = .fieldDetail
        case kVTCompressionPropertyKey_AspectRatio16x9:
            self = .aspectRatio16x9
        case kVTCompressionPropertyKey_ProgressiveScan:
            self = .progressiveScan
        case kVTCompressionPropertyKey_ColorPrimaries:
            self = .colorPrimaries
        case kVTCompressionPropertyKey_TransferFunction:
            self = .transferFunction
        case kVTCompressionPropertyKey_YCbCrMatrix:
            self = .yCbCrMatrix
        case kVTCompressionPropertyKey_ICCProfile:
            self = .iCCProfile
        case kVTCompressionPropertyKey_MasteringDisplayColorVolume:
            self = .masteringDisplayColorVolume
        case kVTCompressionPropertyKey_ContentLightLevelInfo:
            self = .contentLightLevelInfo
        case kVTCompressionPropertyKey_PixelTransferProperties:
            self = .pixelTransferProperties
        case kVTCompressionPropertyKey_MultiPassStorage:
            self = .multiPassStorage
        case kVTCompressionPropertyKey_EncoderID:
            self = .encoderID
        default:
            return nil
        }
    }
    
    #endif
    
    #if os(iOS) || os(tvOS)
    var rawValue: CFString {
        switch self {
        case .numberOfPendingFrames:
            return kVTCompressionPropertyKey_NumberOfPendingFrames
        case .pixelBufferPoolIsShared:
            return kVTCompressionPropertyKey_PixelBufferPoolIsShared
        case .videoEncoderPixelBufferAttributes:
            return kVTCompressionPropertyKey_VideoEncoderPixelBufferAttributes
        case .maxKeyFrameInterval:
            return kVTCompressionPropertyKey_MaxKeyFrameInterval
        case .maxKeyFrameIntervalDuration:
            return kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration
        case .allowTemporalCompression:
            return kVTCompressionPropertyKey_AllowTemporalCompression
        case .allowFrameReordering:
            return kVTCompressionPropertyKey_AllowFrameReordering
        case .averageBitRate:
            return kVTCompressionPropertyKey_AverageBitRate
        case .dataRateLimits:
            return kVTCompressionPropertyKey_DataRateLimits
        case .quality:
            return kVTCompressionPropertyKey_Quality
        case .moreFramesBeforeStart:
            return kVTCompressionPropertyKey_MoreFramesBeforeStart
        case .moreFramesAfterEnd:
            return kVTCompressionPropertyKey_MoreFramesAfterEnd
        case .profileLevel:
            return kVTCompressionPropertyKey_ProfileLevel
        case .h264EntropyMode:
            return kVTCompressionPropertyKey_H264EntropyMode
        case .depth:
            return kVTCompressionPropertyKey_Depth
        case .maxFrameDelayCount:
            return kVTCompressionPropertyKey_MaxFrameDelayCount
        case .maxH264SliceBytes:
            return kVTCompressionPropertyKey_MaxH264SliceBytes
        case .realTime:
            return kVTCompressionPropertyKey_RealTime
        case .sourceFrameCount:
            return kVTCompressionPropertyKey_SourceFrameCount
        case .expectedFrameRate:
            return kVTCompressionPropertyKey_ExpectedFrameRate
        case .expectedDuration:
            return kVTCompressionPropertyKey_ExpectedDuration
        case .baseLayerFrameRate:
            return kVTCompressionPropertyKey_BaseLayerFrameRate
        case .cleanAperture:
            return kVTCompressionPropertyKey_CleanAperture
        case .pixelAspectRatio:
            return kVTCompressionPropertyKey_PixelAspectRatio
        case .fieldCount:
            return kVTCompressionPropertyKey_FieldCount
        case .fieldDetail:
            return kVTCompressionPropertyKey_FieldDetail
        case .aspectRatio16x9:
            return kVTCompressionPropertyKey_AspectRatio16x9
        case .progressiveScan:
            return kVTCompressionPropertyKey_ProgressiveScan
        case .colorPrimaries:
            return kVTCompressionPropertyKey_ColorPrimaries
        case .transferFunction:
            return kVTCompressionPropertyKey_TransferFunction
        case .yCbCrMatrix:
            return kVTCompressionPropertyKey_YCbCrMatrix
        case .iCCProfile:
            return kVTCompressionPropertyKey_ICCProfile
        case .masteringDisplayColorVolume:
            return kVTCompressionPropertyKey_MasteringDisplayColorVolume
        case .contentLightLevelInfo:
            return kVTCompressionPropertyKey_ContentLightLevelInfo
        case .pixelTransferProperties:
            return kVTCompressionPropertyKey_PixelTransferProperties
        case .multiPassStorage:
            return kVTCompressionPropertyKey_MultiPassStorage
        case .encoderID:
            return kVTCompressionPropertyKey_EncoderID
        }
    }
    #elseif os(macOS)
    var rawValue: CFString {
        switch self {
        case .numberOfPendingFrames:
            return kVTCompressionPropertyKey_NumberOfPendingFrames
        case .pixelBufferPoolIsShared:
            return kVTCompressionPropertyKey_PixelBufferPoolIsShared
        case .videoEncoderPixelBufferAttributes:
            return kVTCompressionPropertyKey_VideoEncoderPixelBufferAttributes
        case .maxKeyFrameInterval:
            return kVTCompressionPropertyKey_MaxKeyFrameInterval
        case .maxKeyFrameIntervalDuration:
            return kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration
        case .allowTemporalCompression:
            return kVTCompressionPropertyKey_AllowTemporalCompression
        case .allowFrameReordering:
            return kVTCompressionPropertyKey_AllowFrameReordering
        case .averageBitRate:
            return kVTCompressionPropertyKey_AverageBitRate
        case .dataRateLimits:
            return kVTCompressionPropertyKey_DataRateLimits
        case .quality:
            return kVTCompressionPropertyKey_Quality
        case .moreFramesBeforeStart:
            return kVTCompressionPropertyKey_MoreFramesBeforeStart
        case .moreFramesAfterEnd:
            return kVTCompressionPropertyKey_MoreFramesAfterEnd
        case .profileLevel:
            return kVTCompressionPropertyKey_ProfileLevel
        case .h264EntropyMode:
            return kVTCompressionPropertyKey_H264EntropyMode
        case .depth:
            return kVTCompressionPropertyKey_Depth
        case .maxFrameDelayCount:
            return kVTCompressionPropertyKey_MaxFrameDelayCount
        case .maxH264SliceBytes:
            return kVTCompressionPropertyKey_MaxH264SliceBytes
        case .realTime:
            return kVTCompressionPropertyKey_RealTime
        case .sourceFrameCount:
            return kVTCompressionPropertyKey_SourceFrameCount
        case .expectedFrameRate:
            return kVTCompressionPropertyKey_ExpectedFrameRate
        case .expectedDuration:
            return kVTCompressionPropertyKey_ExpectedDuration
        case .baseLayerFrameRate:
            return kVTCompressionPropertyKey_BaseLayerFrameRate
        case .enableHardwareAcceleratedVideoEncoder:
            return kVTVideoEncoderSpecification_EnableHardwareAcceleratedVideoEncoder
        case .requireHardwareAcceleratedVideoEncoder:
            return kVTVideoEncoderSpecification_RequireHardwareAcceleratedVideoEncoder
        case .usingHardwareAcceleratedVideoEncoder:
            return kVTCompressionPropertyKey_UsingHardwareAcceleratedVideoEncoder
        case .forceKeyFrame:
            return kVTEncodeFrameOptionKey_ForceKeyFrame
        case .cleanAperture:
            return kVTCompressionPropertyKey_CleanAperture
        case .pixelAspectRatio:
            return kVTCompressionPropertyKey_PixelAspectRatio
        case .fieldCount:
            return kVTCompressionPropertyKey_FieldCount
        case .fieldDetail:
            return kVTCompressionPropertyKey_FieldDetail
        case .aspectRatio16x9:
            return kVTCompressionPropertyKey_AspectRatio16x9
        case .progressiveScan:
            return kVTCompressionPropertyKey_ProgressiveScan
        case .colorPrimaries:
            return kVTCompressionPropertyKey_ColorPrimaries
        case .transferFunction:
            return kVTCompressionPropertyKey_TransferFunction
        case .yCbCrMatrix:
            return kVTCompressionPropertyKey_YCbCrMatrix
        case .iCCProfile:
            return kVTCompressionPropertyKey_ICCProfile
        case .masteringDisplayColorVolume:
            return kVTCompressionPropertyKey_MasteringDisplayColorVolume
        case .contentLightLevelInfo:
            return kVTCompressionPropertyKey_ContentLightLevelInfo
        case .pixelTransferProperties:
            return kVTCompressionPropertyKey_PixelTransferProperties
        case .multiPassStorage:
            return kVTCompressionPropertyKey_MultiPassStorage
        case .encoderID:
            return kVTCompressionPropertyKey_EncoderID
        }
    }
    #endif
}
