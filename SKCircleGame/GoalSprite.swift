//
//  GoalPath.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 11/21/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class GoalSprite: ShrinkableSprite {
    
    var action: SKAction! = nil
    
    var texturePath: PathTexture
    
    init(level: Int, model: GameModel) {
        texturePath = GoalSprite.goalPathTextures[level]!
        
        super.init(level: level, model: model, texture: texturePath.texture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var goalPathTextures = [Int : PathTexture]()

    static func loadTextures() {
        for level in 1...6 {
            let outerPath = UIBezierPath(arcCenter: CGPoint.zero, radius: CGFloat(((Constants.scaledRadius * CGFloat(level)) + (Constants.scaledRadius * 2 + Constants.lineWidth))), startAngle: CGFloat.radian(fromDegree: -50), endAngle: CGFloat.radian(fromDegree: 360), clockwise: false)
            
            goalPathTextures[level] = PathTexture(level: level, crop: outerPath.bounds, radius: (Constants.xScaledIncrease * CGFloat(level)) + Constants.scaledRadius, startAngle: 0, endAngle: -50, clockwise: false, color: UIColor.white)
        }
    }
    
}
