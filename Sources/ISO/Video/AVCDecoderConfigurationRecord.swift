//
//  AVCDecoderConfigurationRecord.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/4/12.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import AVFoundation
import AnyBinaryCodable

/* ISO/IEC 14496-15:2010

aligned(8) class AVCDecoderConfigurationRecord {
    unsigned int(8) configurationVersion = 1;
    unsigned int(8) AVCProfileIndication;
    unsigned int(8) profile_compatibility;
    unsigned int(8) AVCLevelIndication;
    
    bit(6) reserved = ‘111111’b;
    unsigned int(2) lengthSizeMinusOne;
    
    bit(3) reserved = ‘111’b;
    unsigned int(5) numOfSequenceParameterSets;
    
    for (i=0; i< numOfSequenceParameterSets; i++) {
        unsigned int(16) sequenceParameterSetLength ;
        bit(8*sequenceParameterSetLength) sequenceParameterSetNALUnit;
    }
    
    unsigned int(8) numOfPictureParameterSets;
    
    for (i=0; i< numOfPictureParameterSets; i++) {
        unsigned int(16) pictureParameterSetLength;
        bit(8*pictureParameterSetLength) pictureParameterSetNALUnit;
    }
}
*/

public struct AVCDecoderConfigurationRecord: Equatable {
    
    public let configurationVersion: UInt8
    public let avcProfileIndication: UInt8
    public let profileCompatibility: UInt8
    public let avcLevelIndication: UInt8
    public let lengthSizeMinusOne: UInt8
    
    public let numOfSequenceParameterSets: UInt8
    /// SPS
    public let sequenceParameterSetNALUnits: [Data]
    
    public let numOfPictureParameterSets: UInt8
    /// PPS
    public let pictureParameterSetNALUnits: [Data]
    
    public var nalUnitHeaderLength: Int32 {
        return Int32(lengthSizeMinusOne + 1)
    }
    
    private init(configurationVersion: UInt8,
                 avcProfileIndication: UInt8,
                 profileCompatibility: UInt8,
                 avcLevelIndication: UInt8,
                 lengthSizeMinusOne: UInt8,
                 numOfSequenceParameterSets: UInt8,
                 sequenceParameterSetNALUnits: [Data],
                 numOfPictureParameterSets: UInt8,
                 pictureParameterSetNALUnits: [Data]) {
        self.configurationVersion = configurationVersion
        self.avcProfileIndication = avcProfileIndication
        self.profileCompatibility = profileCompatibility
        self.avcLevelIndication = avcLevelIndication
        self.lengthSizeMinusOne = lengthSizeMinusOne
        self.numOfSequenceParameterSets = numOfSequenceParameterSets
        self.sequenceParameterSetNALUnits = sequenceParameterSetNALUnits
        self.numOfPictureParameterSets = numOfPictureParameterSets
        self.pictureParameterSetNALUnits = pictureParameterSetNALUnits
    }
}

// MARK: - BinaryCodable
extension AVCDecoderConfigurationRecord: BinaryCodable {
    
    public init(from decoder: BinaryDecoder) throws {
        var container = decoder.container()
        let configurationVersion: UInt8 = try container.decode(using: .big)
        let avcProfileIndication: UInt8 = try container.decode(using: .big)
        let profileCompatibility: UInt8 = try container.decode(using: .big)
        let avcLevelIndication: UInt8 = try container.decode(using: .big)
        let lengthSizeMinusOne: UInt8 = try container.decode(using: .big) & 0b00000011
        
        let numOfSequenceParameterSets: UInt8 = try container.decode(using: .big) & 0b00011111
        var sequenceParameterSetNALUnits: [Data] = []
        for _ in 0..<Int(numOfSequenceParameterSets) {
            let length: UInt16 = try container.decode(using: .big)
            let sequenceParameterSetNALUnit: Data = try container.decode(length: Int(length))
            sequenceParameterSetNALUnits.append(sequenceParameterSetNALUnit)
        }
        
        let numOfPictureParameterSets: UInt8 = try container.decode(using: .big)
        var pictureParameterSetNALUnits: [Data] = []
        for _ in 0..<Int(numOfPictureParameterSets) {
            let length: UInt16 = try container.decode(using: .big)
            let pictureParameterSetNALUnit: Data = try container.decode(length: Int(length))
            pictureParameterSetNALUnits.append(pictureParameterSetNALUnit)
        }
        
        self.init(configurationVersion: configurationVersion,
                  avcProfileIndication: avcProfileIndication,
                  profileCompatibility: profileCompatibility,
                  avcLevelIndication: avcLevelIndication,
                  lengthSizeMinusOne: lengthSizeMinusOne,
                  numOfSequenceParameterSets: numOfSequenceParameterSets,
                  sequenceParameterSetNALUnits: sequenceParameterSetNALUnits,
                  numOfPictureParameterSets: numOfPictureParameterSets,
                  pictureParameterSetNALUnits: pictureParameterSetNALUnits)
    }
    
    public func encode(to encoder: BinaryEncoder) {
        var container = encoder.container()
        container.encode(configurationVersion, using: .big)
        container.encode(avcProfileIndication, using: .big)
        container.encode(profileCompatibility, using: .big)
        container.encode(avcLevelIndication, using: .big)
        assert(lengthSizeMinusOne <= 0b00000011, "invalid lengthSizeMinusOne=\(lengthSizeMinusOne), Out Of Range")
        container.encode(lengthSizeMinusOne + 0b11111100, using: .big)
        
        assert(numOfSequenceParameterSets <= 0b00011111, "invalid numOfSequenceParameterSets=\(numOfSequenceParameterSets), Out Of Range")
        container.encode(numOfSequenceParameterSets + 0b11100000, using: .big)
        for index in 0..<sequenceParameterSetNALUnits.count {
            container.encode(UInt16(sequenceParameterSetNALUnits[index].count), using: .big)
            container.encode(sequenceParameterSetNALUnits[index])
        }
        
        container.encode(numOfPictureParameterSets, using: .big)
        for index in 0..<pictureParameterSetNALUnits.count {
            container.encode(UInt16(pictureParameterSetNALUnits[index].count), using: .big)
            container.encode(pictureParameterSetNALUnits[index])
        }
    }
}

extension AVCDecoderConfigurationRecord {
    
    public init(data: Data) throws {
        let decoder = BinaryDataDecoder()
        self = try decoder.decode(AVCDecoderConfigurationRecord.self, from: data)
    }
    
    public func dataBytes() -> Data {
        let encoder = BinaryDataEncoder()
        return encoder.encode(self)
    }
}

extension AVCDecoderConfigurationRecord {
    
    public func makeFormatDescription() throws -> CMVideoFormatDescription {
        let sequenceParameterSetNALUnitsArray = Array(sequenceParameterSetNALUnits[0])
        let pictureParameterSetNALUnitsArray = Array(pictureParameterSetNALUnits[0])
        var parameterSetPointers: [UnsafePointer<UInt8>] = [
            UnsafePointer<UInt8>(sequenceParameterSetNALUnitsArray),
            UnsafePointer<UInt8>(pictureParameterSetNALUnitsArray),
        ]
        var parameterSetSizes: [Int] = [
            sequenceParameterSetNALUnits[0].count,
            pictureParameterSetNALUnits[0].count,
        ]
        
        var formatDescriptionOut: CMVideoFormatDescription?
        let status = CMVideoFormatDescriptionCreateFromH264ParameterSets(allocator: kCFAllocatorDefault, parameterSetCount: 2, parameterSetPointers: &parameterSetPointers, parameterSetSizes: &parameterSetSizes, nalUnitHeaderLength: nalUnitHeaderLength, formatDescriptionOut: &formatDescriptionOut)
        guard let formatDescription = formatDescriptionOut else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
        return formatDescription
    }
}
