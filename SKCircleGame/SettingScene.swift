//
//  SettingScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 1/19/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class SettingScene: ClickableScene {
    
    override func didMove(to view: SKView) {
        self.sceneTitle(name: "Settings")
    }
    
    deinit {
        print("Deinit of GameLoseScene")
    }
    
}
