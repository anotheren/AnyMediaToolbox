//
//  Ex+Bool.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2018/1/21.
//  Copyright © 2018-2020 anotheren.com. All rights reserved.
//

import Foundation

extension Bool {
    
    var cfBoolean: CFBoolean {
        switch self {
        case true:
            return kCFBooleanTrue
        case false:
            return kCFBooleanFalse
        }
    }
}
