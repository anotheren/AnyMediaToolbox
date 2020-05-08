//
//  Ex+CMSampleBuffer.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/21.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import CoreMedia

extension CMSampleBuffer {
    
    public var dependsOnOthers: Bool {
        if let attachments: CFArray = CMSampleBufferGetSampleAttachmentsArray(self, createIfNecessary: false) {
            if let attachment = unsafeBitCast(CFArrayGetValueAtIndex(attachments, 0), to: CFDictionary.self) as? [CFString: Any] {
                if let result = attachment[kCMSampleAttachmentKey_DependsOnOthers] as? Bool {
                    return result
                }
            }
        }
        return false
    }
    
    public var timingInfo: CMSampleTimingInfo {
        return CMSampleTimingInfo(duration: duration, presentationTimeStamp: presentationTimeStamp, decodeTimeStamp: decodeTimeStamp)
    }
}
