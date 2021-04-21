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
    private var _leftSibling = [NodeRelation<NodeItem>]()
    private var _rightSibling = [NodeRelation<NodeItem>]()
    
    public var parent: NodeRelation<NodeItem>? { _parent }
    public var children: [NodeRelation<NodeItem>] { _children }
    public var leftSibling: [NodeRelation<NodeItem>] { _leftSibling }
    public var rightSibling: [NodeRelation<NodeItem>] { _rightSibling }
    
    
    var item: NodeItem
    
    var relationText = ""
    
    func setParent(relation: NodeRelation<NodeItem>) {
        _parent = relation
        relation._children.append(self)
    }
    
    func setLeftSibling(relations: [NodeRelation<NodeItem>]) {
        _leftSibling = relations
        for relation in relations {
            relation._rightSibling.append(self)
        }
    }
    
    func setRightSibling(relations: [NodeRelation<NodeItem>]) {
        _rightSibling = relations
        for relation in relations {
            relation._leftSibling.append(self)
        }
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
