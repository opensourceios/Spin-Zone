//
//  ShinkableSprite.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 11/22/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ShrinkableSprite: SKSpriteNode {

    var level: Int
    let model: GameModel
    
    var start: Int {
        return (level - 1) * 5
    }
    
    var end: Int {
        return (level * 5) - 1
    }
    
    init(level: Int, model: GameModel, texture: SKTexture) {
        self.level = level
        self.model = model

        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.position = Constants.center
    }
    
    func shrink() {
        level -= 1
 
        if level <= 0 {
            (self as? TrackSprite)?.fadeOut()
        } else {
            let initialLineWidth = Constants.lineWidth
            
            let scale: CGFloat!
            let shape: SKShapeNode!
            
            if self is TrackSprite {
                scale = TrackSprite.trackPathTextures[level]!.texture.size().height / TrackSprite.trackPathTextures[level + 1]!.texture.size().height
                shape = PathTexture.trackShapes[level + 1]!.copy() as! SKShapeNode
                
                if level == 1 {
                    model.levelOneTrack = (self as! TrackSprite)
                    model.updateBall()
                }
                (self as! TrackSprite).goalSprite.shrink()
            } else {
                scale = GoalSprite.goalPathTextures[level]!.texture.size().height / GoalSprite.goalPathTextures[level + 1]!.texture.size().height
                shape = PathTexture.goalShapes[level + 1]!.copy() as! SKShapeNode
                shape.alpha = 0.15
                if level == 1 {
                    model.levelOneGoal = (self as! GoalSprite)
                    model.updateBall()
                }
            }
            
            let finalLineWidth = initialLineWidth / scale
            let animationDuration = 0.1625
            
            let scaleAction = SKAction.scale(by: scale, duration: animationDuration)

            let lineWidthAction = SKAction.customAction(withDuration: animationDuration) { (shapeNode, time) in
                if let shape = shapeNode as? SKShapeNode {
                    let progress = time / CGFloat(animationDuration)
                    shape.lineWidth = initialLineWidth + progress * (finalLineWidth - initialLineWidth)
                }
            }
                        
            self.texture = nil
            shape.zRotation = self.zRotation
            shape.position = self.position
            
            if let t = self as? TrackSprite {
                shape.run(t.action)
            } else if let g  = self as? GoalSprite {
                shape.run(g.action)
            }
            
            let onFinish = SKAction.run {
                self.removeFromParent()
                shape.removeFromParent()
                
                if self is TrackSprite {
                    let oldTrack = (self as! TrackSprite)
                    let oldGoal = oldTrack.goalSprite
                    
                    let goal = GoalSprite(level: self.level, model: self.model)
                    let track = TrackSprite(level: self.level, model: self.model, goalSprite: goal)
                    
                    track.time = oldTrack.time
                    self.model.clockwise = track.clockwise
                    track.clockwise = oldTrack.clockwise
                    
                    goal.removeAllActions()
                    track.removeAllActions()
                    
                    goal.zRotation = self.zRotation
                    track.zRotation = self.zRotation
                    
                    goal.action = oldGoal.action
                    track.action = oldTrack.action
                    
                    goal.run(oldGoal.action)
                    track.run(oldTrack.action)
                    
                    self.model.scene.addChild(goal)
                    self.model.scene.addChild(track)
                    
                    oldTrack.removeFromParent()
                    oldGoal.removeFromParent()
                    
                    if self.level == 1 {
                        self.model.levelOneTrack = track
                        self.model.levelOneGoal = goal
                    }
                }
            }
            
            model.scene.addChild(shape)
            
            let group = SKAction.sequence([SKAction.group([scaleAction, lineWidthAction]), onFinish])
                        
            shape.run(group)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
