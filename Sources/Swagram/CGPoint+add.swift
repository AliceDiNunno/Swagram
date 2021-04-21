//
//  CGPoint+add.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 21/04/2021.
//

import Foundation
import UIKit

extension CGPoint {
    func add(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
}
