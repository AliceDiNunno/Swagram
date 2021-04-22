//
//  Swagram.swift
//  swagramprototype
//
//  Created by Alice Di Nunno on 19/04/2021.
//

import Foundation
import UIKit

public class Swagram: UIViewController, UIGestureRecognizerDelegate {
    public var delegate: SwagramDelegate? = nil {
        didSet {
            reload()
        }
    }
    
    private var viewList = [UIView]()
    private var nodeCache = [Node: CGRect]()
    var lastPoint = CGPoint.zero
    var translationOffset = CGPoint.zero

    func draw(node: Node, at: CGPoint) {
        guard delegate != nil else { return }
        
        let id = node.id
        let delview = delegate!.view(for: id)
        let delviewSize = delegate!.sizeForView(with: id)
        
        view.addSubview(delview)
        
        let x: Int =  (Int(at.x) * Int(delviewSize.width)) + (30 * Int(at.x)) + Int(translationOffset.x)
        let y: Int = (Int(at.y+3) * Int(delviewSize.height)) + (30 * Int(at.y)) + Int(translationOffset.y)
                
        nodeCache[node] = CGRect(origin: CGPoint(x: x, y: y), size: delviewSize)
        
        delview.frame = nodeCache[node]!
    }
    
    func makeLineLayer(_ layer: CALayer?, lineFromPointA pointA: CGPoint, toPointB pointB: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: pointA)
        linePath.addLine(to: pointB)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.lineCap = .round
        line.lineJoin = .miter
        line.opacity = 1.0
        line.lineWidth = 5.0
        line.strokeColor = UIColor.white.cgColor
        layer?.addSublayer(line)
    }
        
    func drawConnections(node: Node) {
        guard delegate != nil else { return }
        
        for child in node.children {
            if (nodeCache.keys.contains(node) && nodeCache.keys.contains(child)) {
                let nodePos = nodeCache[node]!
                let childPos = nodeCache[child]!
    
                var startPoint = CGPoint()
                var endPoint = CGPoint()
                
                if (child.relationToParent == .child) {
                    startPoint = CGPoint(x: nodePos.midX, y: nodePos.maxY)
                    endPoint = CGPoint(x: childPos.midX, y: childPos.minY)
                } else if (child.relationToParent == .sibling) {
                    startPoint = CGPoint(x: nodePos.maxX, y: nodePos.midY)
                    endPoint = CGPoint(x: childPos.minX, y: childPos.midY)
                }
                
                makeLineLayer(self.view.layer, lineFromPointA: startPoint, toPointB: endPoint)
                
            }
            
            
            drawConnections(node: child)
        }
    }
    
    public func reload() {
        guard delegate != nil else {
            return
        }
        
        let coords: [Node: CGPoint] = buildMatrix()
        
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        for layer in view.layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        

        for node in coords.keys {
            draw(node: node, at: coords[node]!)
        }
        
        let mainNode = coords.keys.filter {
            $0.relationToParent == .root
        }.first
        
        if mainNode != nil {
            drawConnections(node: mainNode!)
        }
    }
    
    @objc func graphPanned(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        

        if gesture.state == UIGestureRecognizer.State.began {
            gesture.setTranslation(translationOffset, in: self.view)
        }
        
        
        if  gesture.state == UIGestureRecognizer.State.changed {
            translationOffset = translation
            
            
            reload()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(graphPanned))
        self.view.addGestureRecognizer(gesture)
        self.view.isUserInteractionEnabled = true
        gesture.delegate = self

        
        reload()
    }
    
    func drawNode(id: String) -> Node {
        let thisNode = Node()
        thisNode.id = id
        
        let siblings = delegate!.sibling(of: id)
        let siblingsCount = siblings.count
        var previousHeight = 0
        for (index, sibling) in siblings.enumerated() {
            var siblingNode = drawNode(id: sibling)
            siblingNode.relationToParent = .sibling
            siblingNode.layoutPosition = getLayoutPosition(index: index, total: siblingsCount)
            siblingNode.relativePosition = CGPoint(x: 1, y: previousHeight + alignmentPositionChange(layout: siblingNode.layoutPosition, index: index, total: siblingsCount))
            previousHeight += Int(siblingNode.size.height)
            thisNode.add(child: &siblingNode)
        }
        
        var previousWidth = 0
        let children = delegate!.children(of: id)
        let childrenCount = children.count
        for (index, child) in children.enumerated() {
            var childNode = drawNode(id: child)
            childNode.relationToParent = .child
            childNode.layoutPosition = getLayoutPosition(index: index, total: siblingsCount)
            childNode.relativePosition = CGPoint(x: previousWidth + alignmentPositionChange(layout: childNode.layoutPosition, index: index, total: childrenCount), y: 1)
            previousWidth += Int(childNode.size.width)
            thisNode.add(child: &childNode)
        }
        
        return thisNode
    }
    
    func buildMatrix() -> [Node: CGPoint] {
        let mainNodeId = delegate!.mainNode()
        let mainNode = drawNode(id: mainNodeId)

        
        let nodes = mainNode.allNodes
        
        var nodeDict = [Node: CGPoint]()
        
        for element in nodes {
            let drawPosition = element.absolutePosition
            
            nodeDict[element] = drawPosition
        }
        
        return nodeDict
    }
}
