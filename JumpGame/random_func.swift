//
//  random_func.swift
//  JumpGame
//
//  Created by Darren Freeman on 5/25/19.
//  Copyright © 2019 Darren Freeman. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    static func random() -> CGFloat{
    
    return CGFloat(Float(arc4random()) / 0xFFFFFF)
    }
    
     static func random(min : CGFloat, max : CGFloat) -> CGFloat{
        
        return CGFloat.random() * (max - min) + min
    }
}
