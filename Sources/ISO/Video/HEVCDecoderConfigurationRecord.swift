//
//  HEVCDecoderConfigurationRecord.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/4/12.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation

/* ISO/IEC 14496-15:2014
 
aligned(8) class HEVCDecoderConfigurationRecord {
 
    unsigned int(8) configurationVersion = 1;
 
    unsigned int(2) general_profile_space;
    unsigned int(1) general_tier_flag;
    unsigned int(5) general_profile_idc;
 
    unsigned int(32) general_profile_compatibility_flags;
 
    unsigned int(48) general_constraint_indicator_flags;
 
    unsigned int(8) general_level_idc;
 
    bit(4) reserved = ‘1111’b;
    unsigned int(12) min_spatial_segmentation_idc;
 
    bit(6) reserved = ‘111111’b;
    unsigned int(2) parallelismType;
 
    bit(6) reserved = ‘111111’b;
    unsigned int(2) chroma_format_idc;
 
    bit(5) reserved = ‘11111’b;
    unsigned int(3) bit_depth_luma_minus8;
 
    bit(5) reserved = ‘11111’b;
    unsigned int(3) bit_depth_chroma_minus8;
 
    bit(16) avgFrameRate;
 
    bit(2) constantFrameRate;
    bit(3) numTemporalLayers;
    bit(1) temporalIdNested;
    unsigned int(2) lengthSizeMinusOne;
 
    unsigned int(8) numOfArrays;
 
    for (j=0; j < numOfArrays; j++) {
        bit(1) array_completeness;
        unsigned int(1) reserved = 0;
        unsigned int(6) NAL_unit_type;
 
        unsigned int(16) numNalus;
 
        for (i=0; i< numNalus; i++) {
            unsigned int(16) nalUnitLength;
            bit(8*nalUnitLength) nalUnit;
        }
    }
}
*/
