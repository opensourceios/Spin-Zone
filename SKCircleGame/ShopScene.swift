//
//  ShopScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 1/19/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ShopScene: ClickableScene {
    
    override func didMove(to view: SKView) {
        self.sceneTitle(name: "Shop")
    }
    
    deinit {
        print("Deinit of ShopScene")
    }
    
}
