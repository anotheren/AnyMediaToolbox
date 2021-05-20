//
//  Ex+CMFormatDescription.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/20.
//  Copyright © 2018-2021 anotheren.com. All rights reserved.
//

import CoreMedia

extension CMVideoFormatDescription {
    
    public var avcC: Data? {
        if let atoms = CMFormatDescriptionGetExtension(self, extensionKey: kCMFormatDescriptionExtension_SampleDescriptionExtensionAtoms) as? [String: Any] {
            return atoms["avcC"] as? Data
        }
        return nil
    }
}
