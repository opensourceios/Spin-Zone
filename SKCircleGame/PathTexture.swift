//
//  PathTexture.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 11/22/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class PathTexture {
    
    let texture: SKTexture
    let lineWidth: CGFloat = Constants.lineWidth
    
    let innerPath: UIBezierPath
    let outerPath: UIBezierPath
    let normalPath: UIBezierPath
    let level: Int
    
    static var trackShapes = [Int : SKShapeNode]()
    static var goalShapes = [Int : SKShapeNode]()
    
    init(level: Int, radius: CGFloat, startAngle: Int, endAngle: Int, clockwise: Bool, color: UIColor) {
        self.level = level
        
        normalPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat.radian(fromDegree: startAngle), endAngle: CGFloat.radian(fromDegree: endAngle), clockwise: clockwise)
        outerPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius + (lineWidth / 2), startAngle: CGFloat.radian(fromDegree: startAngle), endAngle: CGFloat.radian(fromDegree: endAngle), clockwise: clockwise)
        innerPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius - (lineWidth / 2), startAngle: CGFloat.radian(fromDegree: startAngle), endAngle: CGFloat.radian(fromDegree: endAngle), clockwise: clockwise)
        
        let shape = SKShapeNode(path: normalPath.cgPath)
        shape.lineWidth = lineWidth
        shape.strokeColor = color
        PathTexture.trackShapes[level] = shape
        
        texture = SKView().texture(from: shape, crop: self.outerPath.bounds)!
    }
    
    init(level: Int, crop: CGRect, radius: CGFloat, startAngle: Int, endAngle: Int, clockwise: Bool, color: UIColor) {
        self.level = level
        
        normalPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat.radian(fromDegree: startAngle), endAngle: CGFloat.radian(fromDegree: endAngle), clockwise: clockwise)
        innerPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius - (lineWidth / 2), startAngle: CGFloat.radian(fromDegree: startAngle), endAngle: CGFloat.radian(fromDegree: endAngle), clockwise: clockwise)
        outerPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius + (lineWidth / 2), startAngle: CGFloat.radian(fromDegree: startAngle), endAngle: CGFloat.radian(fromDegree: endAngle), clockwise: clockwise)
        
        let shape = SKShapeNode(path: normalPath.cgPath)
        shape.lineWidth = lineWidth
        shape.strokeColor = color
        shape.alpha = 0.15
        PathTexture.goalShapes[level] = shape
        
        texture = SKView().texture(from: shape, crop: crop)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
