//
//  GameScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 10/10/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

	var model: GameModel!
	
	var scoreLabel: SKLabelNode!
	
	var themeColor: UIColor!
	
	var score: Int {
		get {
			return Int(scoreLabel.text!)!
		}
		set {
			scoreLabel.text = String(newValue)
		}
	}
	
	override func didMove(to view: SKView) {
		self.physicsWorld.contactDelegate = self
		
		let level = GameModel.currentLevel
		
		self.model = GameModel(scene: self, level: level)
		
		self.model.createTracks()
		self.model.createPauseButton()
	}
	
	// used to block touches while the physics is being applied
	var allowTouchBegan = true
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !allowTouchBegan {
			return
		}
		
		for node in model.scene.children {
			if let track = node as? TrackSprite {
				track.shrink()
			}
		}
		
		let seconds = 0.1725
		
		allowTouchBegan = false
		
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
			self.touchable = true
			self.model.applyTrackPhysics()
			self.allowTouchBegan = true
		})
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds + 0.05, execute: {
			self.model.applyGoalPhysics()
		})
	}
	
	// used to block all contacts so it runs only once
	var touchable = true
	func didBegin(_ contact: SKPhysicsContact) {
		if !touchable {
			return
		}
	
		let touched = contact.bodyA
	
		if touched.categoryBitMask == Catigory.goal.rawValue {
			model.updateScore()
		} else if touched.categoryBitMask == Catigory.track.rawValue {
			model.lose()
		}
		
		touchable = false
	}
}
