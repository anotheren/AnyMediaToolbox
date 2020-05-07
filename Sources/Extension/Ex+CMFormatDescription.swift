//
//  Ex+CMFormatDescription.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/20.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation
import CoreMedia
import CoreAudio

extension CMVideoFormatDescription {
    
    public var avcC: Data? {
        if let atoms = CMFormatDescriptionGetExtension(self, extensionKey: "SampleDescriptionExtensionAtoms" as CFString) as? [String: Any] {
            return atoms["avcC"] as? Data
        }
        return nil
    }
}
