//
//  ScoreLabel.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 11/24/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKLabelNode {
    
    lazy var levelText: SKLabelNode = {
        let label = SKLabelNode(title: "Level", fontSize: 40.0)
        label.alpha = 0.90
        label.position = CGPoint(x: Constants.center.x, y: 40.yScaled * 2)
        return label
    }()
    
    lazy var levelTextBackground: SKSpriteNode = {
        let shape = SKShapeNode(rectOf: CGSize(width: Constants.currentSize.width, height: 40.yScaled))
        shape.alpha = 0.10
        shape.strokeColor = UIColor.clear
        shape.fillColor = UIColor.white
        let sprite = SKSpriteNode(texture: SKView().texture(from: shape))
        sprite.position = CGPoint(x: Constants.center.x, y: 40.yScaled * 2)
        return sprite
    }()
    
    lazy var levelScore: SKLabelNode = {
        let label = SKLabelNode(title: String(GameModel.currentLevel), fontSize: 40.0)
        label.alpha = 0.90
        label.position = CGPoint(x: Constants.center.x, y: 40.yScaled)
        return label
    }()
    
    let gameScene: GameScene
    
    var score: Int {
        set {
            self.text = String(newValue)
        }
        
        get {
            return Int(self.text!)!
        }
    } 
    
    init(scene: GameScene) {
        
        self.gameScene = scene

        super.init()
        
        self.fontName = "Junegull"
        self.fontSize = 90.xScaled
        self.fontColor = UIColor.white
        self.text = String(0)
        
        self.position = CGPoint(x: scene.frame.midX, y: scene.frame.maxY - (self.frame.height / 2) - 70.yScaled)
        
        scene.addChild(self)
        scene.addChild(levelText)
        scene.addChild(levelTextBackground)
        scene.addChild(levelScore)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
