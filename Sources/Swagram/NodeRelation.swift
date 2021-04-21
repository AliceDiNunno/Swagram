//
//  NodeRelation.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 19/04/2021.
//

import Foundation

public class NodeRelation<NodeItem> {
    private var _parent = NodeRelation<NodeItem>?(nil)
    private var _children = [NodeRelation<NodeItem>]()
    private var _siblings = [NodeRelation<NodeItem>]()
    
    public var parent: NodeRelation<NodeItem>? { _parent }
    public var children: [NodeRelation<NodeItem>] { _children }
    public var siblings: [NodeRelation<NodeItem>] { _siblings }
    
    
    var item: NodeItem
    
    var relationText = ""
    
    func setParent(relation: NodeRelation<NodeItem>) {
        _parent = relation
        relation._children.append(self)
    }
    
    func setSibling(relations: [NodeRelation<NodeItem>]) {
        _siblings = relations
    }
    
    func setChildren(relations: [NodeRelation<NodeItem>]) {
        _children = relations
        for relation in relations {
            relation._parent = self
        }
        
    }
    
    init(item: NodeItem) {
        self.item = item
    }
}
