//
//  Node.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 21/04/2021.
//

import Foundation
import UIKit

class Node {
    var id = ""
    var index = 0
    var layoutPosition = LayoutPosition.middle
    
    var relationToParent: RelationToParent = .root
    var parent = [Node]()
    var _children = [Node]()
    var children: [Node] {
        return _children
    }
    
    func add(child: inout Node) {
        _children.append(child)
        child.parent = [self]
    }
    
    
    var allNodes: [Node] {
        var array = [self]
        
        for child in children {
            array.append(contentsOf: child.allNodes)
        }
        
        return array
    }
    
    var relativePosition = CGPoint()
    var absolutePosition: CGPoint {
        relativePosition.add(point: parent.first?.absolutePosition ?? CGPoint(x: 0, y: 0))
    }
    
    var size: CGSize {
        get {
            var initialSize = CGSize(width: 1, height: 1)
            
            let nodeChildrenSize = children
                .filter { $0.relationToParent == .child }
                .map { $0.size }
                .reduce(initialSize) {
                    let width = $0.width + $1.width
                    let height = $0.height > $1.height ? $0.height : $1.height
                    
                    return CGSize(width: width, height: height)
                }
            
            let nodeSiblingsSize = children
                .filter { $0.relationToParent == .sibling }
                .map { $0.size }
                .reduce(initialSize) {
                    let height = $0.height + $1.height
                    let width = $0.width > $1.width ? $0.width : $1.width
                    
                    return CGSize(width: width, height: height)
                }
            
            let height = nodeChildrenSize.height > nodeSiblingsSize.height ? nodeChildrenSize.height : nodeSiblingsSize.height
            let width = nodeChildrenSize.width > nodeSiblingsSize.width ? nodeChildrenSize.width : nodeSiblingsSize.width
            initialSize.height = height
            initialSize.width = width
            
            //print("size for: \(id): h:\(initialSize.height), w: \(initialSize.width)")
            return initialSize
        }
    }
}

extension Node: Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
