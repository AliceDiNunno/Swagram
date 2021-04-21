//
//  Calculs2.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 19/04/2021.
//

import Foundation
import UIKit

func getLayoutPosition(index: Int, total: Int) -> LayoutPosition {
    if total == 1 && index == 0 {
        return LayoutPosition.middle
    }
    
    if !total.isMultiple(of: 2) {
        let middle = (total - 1) / 2
        
        if index < middle {
            return LayoutPosition.firstHalf
        }
        
        if index > middle {
            return LayoutPosition.secondHalf
        }
        
        return LayoutPosition.middle
    } else {
        if index < (total / 2) {
            return LayoutPosition.firstHalf
        }
        return LayoutPosition.secondHalf
    }
}

func alignmentPositionChange(layout position: LayoutPosition, index: Int, total: Int) -> Int {
    switch position {
    case .firstHalf:
        return -1 - index
    case .middle:
        return 0
    case .secondHalf:
        return 1 + index - ((total + 1) / 2)
    }
}
