//
//  Node+Hashable.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 21/04/2021.
//

import Foundation

extension Node: Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
