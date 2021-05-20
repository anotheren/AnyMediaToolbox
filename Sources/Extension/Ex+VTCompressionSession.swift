//
//  Ex+VTCompressionSession.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/20.
//  Copyright © 2018-2021 anotheren.com. All rights reserved.
//

import VideoToolbox

extension VTCompressionSession {
    
    func setProperty(_ propertyKey: VTCompressionPropertyKey, value: CFTypeRef) -> OSStatus {
        return VTSessionSetProperty(self, key: propertyKey.rawValue, value: value)
    }
    
    func setProperties(_ propertyDictionary: [VTCompressionPropertyKey: CFTypeRef]) -> OSStatus {
        var dictionary: [CFString: CFTypeRef] = [:]
        propertyDictionary.forEach { dictionary[$0.rawValue] = $1 }
        return VTSessionSetProperties(self, propertyDictionary: dictionary as CFDictionary)
    }
    
    func prepareToEncodeFrames() -> OSStatus {
        return VTCompressionSessionPrepareToEncodeFrames(self)
    }
    
    func invalidate() {
        VTCompressionSessionInvalidate(self)
    }
}
