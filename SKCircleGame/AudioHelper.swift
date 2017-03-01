//
//  AudioHelper.swift
//  Spin Zone
//
//  Created by Nicholas Grana on 2/27/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class AudioHelper {
    
    let scene: SKScene
    
    lazy var ping: SKAudioNode = {
        let ping = SKAudioNode(fileNamed: "Jump.mp3")
        ping.autoplayLooped = false
        self.scene.addChild(ping)
        return ping
    }()
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func playPing() {
        ping.run(SKAction.play())
    }
}
