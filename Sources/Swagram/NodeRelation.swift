//
//  NodeRelation.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 19/04/2021.
//

import Foundation

public class NodeRelation<NodeItem> {
    private(set) public var parent = NodeRelation<NodeItem>?(nil)
    private(set) public var children = [NodeRelation<NodeItem>]()
    private(set) public var siblings = [NodeRelation<NodeItem>]()
    public var item: NodeItem
    
    public func setParent(relation: NodeRelation<NodeItem>) {
        parent = relation
        relation.children.append(self)
    }
    
    public func setSibling(relations: [NodeRelation<NodeItem>]) {
        siblings = relations
    }
    
    public func setChildren(relations: [NodeRelation<NodeItem>]) {
        children = relations
        for relation in relations {
            relation.parent = self
        }
        
    }
    
    public init(item: NodeItem) {
        self.item = item
    }
}
