//
//  ButtonSprite.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/19/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ButtonSprite: SKSpriteNode {

    let buttonTexture = SKTexture(imageNamed: "button")
    let label: SKLabelNode
    var runOnClick: () -> () = { }
    
    init(title: String, under: ButtonSprite?) {
        label = SKLabelNode(title: title, fontSize: Constants.buttonFont, fontName: "Junegull", fontColor: DynamicBackground.currentColor)
        
        super.init(texture: buttonTexture, color: UIColor.white, size: CGSize(width: 245.xScaled, height: 50.xScaled))
        
        self.position = under == nil ? Constants.center : CGPoint(x: under!.position.x, y: under!.position.y - (10.yScaled + self.size.height))
        self.name = title
        label.position = CGPoint(x: self.position.x, y: self.position.y)

        label.zPosition = 3
        self.zPosition = 2
    }
    
    static var circleTexture: SKTexture {
        let circle = SKShapeNode(circleOfRadius: 64)
        circle.fillColor = UIColor.white
        circle.strokeColor = UIColor.white
        return SKView().texture(from: circle)!
    }
    
    init(title: String, position: CGPoint) {
        label = SKLabelNode(text: title)
        
        super.init(texture: ButtonSprite.circleTexture, color: UIColor.red, size: CGSize(width: 128, height: 128))
        
        self.alpha = 0.15
        self.position = position
        self.name = title
        
        let padding = (((self.frame.height / 2) / 2) / 2) / 2
        // label.center
        label.fontName = "Junegull"
        label.position = CGPoint(x: self.position.x + self.frame.width, y: (self.position.y - padding) + self.frame.height)
        label.fontSize = 40
        label.fontColor = UIColor.white
        
        self.position = CGPoint(x: self.position.x + self.frame.width, y: self.position.y + self.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pressed() {
        self.alpha = 0.60
    }
    
    func letGo() {
        self.alpha = 1.0
    }
}
