//
//  CirclePath.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 11/21/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class TrackSprite: ShrinkableSprite {
    
    var clockwise: Bool!
    
    let goalSprite: GoalSprite
    var time: Double!
    
    var action: SKAction! = nil
    
    let texturePath: PathTexture
    
    init(level: Int, model: GameModel, goalSprite: GoalSprite) {
        self.goalSprite = goalSprite
        texturePath = TrackSprite.trackPathTextures[level]!
        
        super.init(level: level, model: model, texture: texturePath.texture)
        
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        self.removeAllActions()
        goalSprite.removeAllActions()
        
        let random = (Double.randomNumber(from: 2, to: 4) * Double.randomNumber(from: 2, to: 4)) / Double.randomNumber(from: 2, to: 4)
        var rotateAction = SKAction.rotate(byAngle: CGFloat(2 * M_PI), duration: random)
        
        if self.model.clockwise {
            rotateAction = SKAction.rotate(byAngle: CGFloat(-2 * M_PI), duration: random)
        }
        
        self.clockwise = self.model.clockwise
        self.model.clockwise = !self.model.clockwise
        self.time = random
        
        action = SKAction.repeatForever( rotateAction)
        
        self.zRotation = CGFloat.radian(fromDegree: Int(Double.randomNumber(from: 0, to: 360)))
        self.goalSprite.zRotation = self.zRotation
        
        self.run(action)
        goalSprite.run(action)
        goalSprite.action = action
    }
    
    func fadeOut() {
        // only add a new top level if the current level is bigger than 4 and if the next level is
        if model.scoreLabel.score > 4 && GameModel.nextLevel >= 5 {
            self.model.addTopLevel()
        }
        
        let fadeOut = SKAction.group([SKAction.fadeOut(withDuration: 0.1625), SKAction.resize(byWidth: -150.xScaled, height: -150.xScaled, duration: 0.1625)])
        let removeTrackFromView = SKAction.sequence([fadeOut, SKAction.run {
            self.removeFromParent()
            }])
        let removeGoalFromView = SKAction.sequence([fadeOut, SKAction.run {
            self.goalSprite.removeFromParent()
            }])
        
        self.run(removeTrackFromView)
        self.goalSprite.run(removeGoalFromView)
 
    }
    
    static var trackPathTextures = [Int : PathTexture]()
    
    static func loadTextures() {
        for level in 1...6 {
            trackPathTextures[level] = PathTexture(level: level, radius: (Constants.xScaledIncrease * CGFloat(level)) + Constants.scaledRadius, startAngle: -50, endAngle: 360, clockwise: false, color: UIColor.white)
        }
    }
    
}
