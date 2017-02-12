//
//  DynamicBackground.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/18/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class DynamicBackground: SKScene {
   
    // MARK: Properties
    
    static var theme = UIColor.grayThemeBackground
    
    static let themes = [
        UIColor.grayThemeBackground,
        UIColor.redThemeBackground,
        UIColor.orangeThemeBackground,
        UIColor.yellowThemeBackground,
        UIColor.greenThemeBackground,
        UIColor.blueThemeBackground,
        UIColor.purpleThemeBackground,
        UIColor.pinkThemeBackground
    ]

    static var currentIndex: Int {
        return UserDefaults.standard.integer(forKey: "color-index")
    }

    static var currentColor: UIColor {
        DynamicBackground.theme = themes[currentIndex]
        return DynamicBackground.themes[currentIndex]
    }
    
    static var nextColor: UIColor {
        let nextIndex = DynamicBackground.currentIndex + 1 > DynamicBackground.themes.count - 1 ? 0 : DynamicBackground.currentIndex + 1
        return DynamicBackground.themes[nextIndex]
    }
    
    var circle: SKSpriteNode!
    
    var stop = false
    var timer: Timer? = nil

    var maxSize: CGFloat {
        return max(max(Constants.topLeft.distance(between: circle.position), Constants.topRight.distance(between: circle.position)), max(Constants.bottomLeft.distance(between: circle.position), Constants.bottomRight.distance(between: circle.position)))
    }
    
    // from 0.0 to 1.0 for time & 3D touch to work on different devices
    var circleSize: CGFloat = 0.0 {
        didSet {
            guard let circle = circle else {
                return
            }
            
            let size = (self.circleSize * maxSize) * 2
            circle.size = CGSize(width: size, height: size)
            
            if (self.circleSize >= 1.0) {
                 self.transitionBackground()
            }
        }
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DynamicBackground.removeCircle), name: NSNotification.Name(rawValue: "RemoveCircle"), object: nil)
    }
    
    // MARK: Circle Functions
    
    func createCircle() -> SKSpriteNode {
        let circle = SKShapeNode(circleOfRadius: self.size.height)
        circle.strokeColor = DynamicBackground.nextColor
        circle.fillColor = DynamicBackground.nextColor
        let sprite = SKSpriteNode(texture: SKView().texture(from: circle)!)
        sprite.zPosition = -1
        sprite.size = CGSize.zero
        return sprite
    }
    
    func transitionBackground() {
        stop = true
        
        self.backgroundColor = DynamicBackground.nextColor
        
        UserDefaults.standard.set(DynamicBackground.currentIndex + 1 > DynamicBackground.themes.count - 1 ? 0 : DynamicBackground.currentIndex + 1, forKey: "color-index")

        removeCircle()
        self.circle = self.createCircle()
        
        // change the fonts
        for node in self.children {
            if let label = node as? SKLabelNode {
                if label.alpha == 1.0 { // only buttons have an alpha of 1.0
                    label.fontColor = DynamicBackground.currentColor
                }
            }
        }
    }
    
    func removeCircle() {
        self.circleSize = 0.0
        self.circle?.removeFromParent()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func update(size: CGFloat) {
        if !stop {
            circleSize = size
        }
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { t in
                self.update(size: self.circleSize + 0.002)
            })
        }
    }
    
    // MARK: Action events

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {

            if circle == nil {
                circle = createCircle()
            }
            
            if circle.scene == nil && !stop {
                circle.position = touch.location(in: self)
                self.addChild(circle)
            }
            
            if #available(iOS 9.0, *) {
                if let view = self.view, view.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    update(size: CGFloat(touch.force / touch.maximumPossibleForce))
                } else {
                    startTimer()
                }
            } else {
                startTimer()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeCircle()
        stop = false
    }
    
    
}
