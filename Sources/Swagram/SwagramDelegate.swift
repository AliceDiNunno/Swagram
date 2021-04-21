//
//  SwagramDelegate.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 19/04/2021.
//

import Foundation
import UIKit

public protocol SwagramDelegate {
    func mainNode() -> String
    func view(for id: String) -> UIView
    func sizeForView(with id: String) -> CGSize
    func parent(of id: String) -> String?
    func children(of id: String) -> [String]
    func sibling(of id: String, to: SiblingDirection) -> [String]
}
