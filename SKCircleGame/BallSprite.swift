//
//  BallSprite.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/10/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class BallSprite: SKSpriteNode {
    
    var action: SKAction! = nil {
        didSet {
            if let _ = action {
                self.removeAllActions()
                self.run(SKAction.repeatForever(action))
            }
        }
    }
    
    init(color: UIColor, view: SKView) {
        let spriteShape = SKShapeNode(circleOfRadius: Constants.ballRadius)
        spriteShape.fillColor = color
        spriteShape.strokeColor = color
        
        let texture = view.texture(from: spriteShape)
        
        super.init(texture: texture, color: color, size: CGSize(width: Constants.ballRadius, height: Constants.ballRadius))
        
        self.size = CGSize(width: Constants.ballRadius, height: Constants.ballRadius)
        let physics = SKPhysicsBody(circleOfRadius: (Constants.ballRadius - 2.xScaled) / 2)
        physics.affectedByGravity = false
        physics.collisionBitMask = 0
        physics.categoryBitMask = Catigory.ball.rawValue
        physics.contactTestBitMask = Contact.track.rawValue | Contact.goal.rawValue
        self.physicsBody = physics
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
