//
//  Extensions.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/18/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

extension UIColor {
    
    static let grayThemeBackground = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.00)
    static let redThemeBackground = UIColor(red:0.54, green:0.01, blue:0.04, alpha:1.00)
    static let orangeThemeBackground = UIColor(red:0.87, green:0.31, blue:0.10, alpha:1.00)
    static let yellowThemeBackground = UIColor(red:1.00, green:0.64, blue:0.00, alpha:1.00)
    static let greenThemeBackground = UIColor(red:0.19, green:0.67, blue:0.15, alpha:1.00)
    static let blueThemeBackground = UIColor(red:0.00, green:0.43, blue:0.73, alpha:1.00)
    static let purpleThemeBackground = UIColor(red:0.18, green:0.13, blue:0.40, alpha:1.00)
    static let pinkThemeBackground = UIColor(red:0.94, green:0.24, blue:0.43, alpha:1.00)
    
}

extension CGPoint {
    
    func distance(between: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - between.x, 2) + pow(self.y - between.y, 2))
    }
    
}

extension CGFloat {
    
    static func radian(fromDegree degree: Int) -> CGFloat {
        return CGFloat((M_PI / 180)) * CGFloat(degree)
    }
    
}

extension Int {
    
    var xScaled: CGFloat {
        return CGFloat(self) * Constants.xScale
    }
    
    var yScaled: CGFloat {
        return CGFloat(self) * Constants.yScale
    }
    
}

extension Double {
    
    static func randomNumber(from: Double, to: Double) -> Double {
        return Double(from) + (Double(drand48()) * (to - from))
    }
    
}

extension SKScene {
    
    func sceneTitle(name: String) {
        let title = SKLabelNode()
        
        title.fontName = "Junegull"
        title.fontSize = Constants.titleFont
        title.fontColor = UIColor.white
        title.position = Constants.sceneTitlePosition
        title.text = name
        title.alpha = 0.30
        title.verticalAlignmentMode = .center
        title.horizontalAlignmentMode = .center
        
        self.addChild(title)
    }
    
    func sceneTitle(name: String, splitter: Character) {
        var i = 0
        var label0: SKLabelNode!
        var label1: SKLabelNode!
        let splits = name.characters.split(separator: splitter)

        for split in splits where i < 2 {
            let label = SKLabelNode(text: String(split))
            label.fontSize = Constants.titleFont
            label.fontColor = UIColor.white
            label.fontName = "Junegull"
            label.alpha = i == 0 ? 0.50 : 0.80
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
                        
            if i == 0 {
                label0 = label
            } else {
                label1 = label
                
                let leftPadding = (self.size.width - label0.frame.width - label1.frame.width - 5) / 2
                
                label0.position = CGPoint(x: leftPadding + label0.frame.width / 2, y: Constants.sceneTitlePosition.y)
                label1.position = CGPoint(x: label0.position.x + (label0.frame.width / 2) + (label1.frame.width / 2) + 5.xScaled, y: Constants.sceneTitlePosition.y)
             
            }
            
            self.addChild(label)
            
            i += 1
        }
    }
    
}

extension SKSpriteNode {
    
    convenience init(shape: SKShapeNode) {
        self.init()
        self.texture = SKView().texture(from: shape)
    }
    
}

extension SKLabelNode {
    
    convenience init(title: String, fontSize: CGFloat, fontName: String = "Junegull", fontColor: UIColor = UIColor.white) {
        self.init(text: title)
        
        self.fontName = fontName
        self.horizontalAlignmentMode = .center
        self.verticalAlignmentMode = .center
        self.fontSize = fontSize
        self.fontColor = fontColor
    }
    
}

extension UIColor {
    
    func lighterColor(percent: Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent));
    }
    
    func darkerColor(percent: Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent));
    }
    
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }

}
