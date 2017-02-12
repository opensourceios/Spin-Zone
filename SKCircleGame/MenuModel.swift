//
//  MenuModel.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/18/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class MenuModel {
    
    enum Scene {
        case game
        case start
        case shop
        case setting
    }
    
    let scenes = ["play" : Scene.game, "try again" : Scene.game, "menu" : Scene.start, "shop": Scene.shop, "settings": Scene.setting]
    let transitions = ["play" : SKTransition.push(with: .left, duration: 0.5), "try again" : SKTransition.push(with: .up, duration: 0.5), "menu" : SKTransition.push(with: .up, duration: 0.5), "shop" : SKTransition.push(with: .right, duration: 0.5), "settings" : SKTransition.push(with: .up, duration: 0.5)]
    
    func create(scene: Scene, current: SKScene) -> SKScene {
        let newScene: SKScene!
        
        switch scene {
            case Scene.game:
                newScene = GameScene(size: Constants.currentSize)
            case Scene.start:
                newScene = GameStartMenu(size: Constants.currentSize)
            case Scene.shop:
                newScene = ShopScene(size: Constants.currentSize)
            case Scene.setting:
                newScene = SettingScene(size: Constants.currentSize)
        }
        newScene.backgroundColor = current.backgroundColor
        // Set the scale mode to scale to fit the window
        newScene.scaleMode = .aspectFill
        return newScene
    }
    
}
