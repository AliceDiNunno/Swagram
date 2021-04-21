//
//  NodeRelation.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 19/04/2021.
//

import Foundation

public class NodeRelation<NodeItem> {
    private(set) var parent = NodeRelation<NodeItem>?(nil)
    private(set) var children = [NodeRelation<NodeItem>]()
    private(set) var siblings = [NodeRelation<NodeItem>]()
    
    var item: NodeItem
    
    var relationText = ""
    
    func setParent(relation: NodeRelation<NodeItem>) {
        parent = relation
        relation.children.append(self)
    }
    
    func setSibling(relations: [NodeRelation<NodeItem>]) {
        siblings = relations
    }
    
    func setChildren(relations: [NodeRelation<NodeItem>]) {
        children = relations
        for relation in relations {
            relation.parent = self
        }
        
    }
    
    init(item: NodeItem) {
        self.item = item
    }
}
