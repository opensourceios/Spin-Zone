//
//  GameStartMenu.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 12/18/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit
import GameKit

class GameStartMenu: ClickableScene {
        
    override func didMove(to view: SKView) {
        self.backgroundColor = DynamicBackground.currentColor
        self.model = MenuModel()
        self.sceneTitle(name: "Spin Zone", splitter: " ")
        
        addButtons()
    }
    
    func addButtons() {
        let play = ButtonSprite(title: "Play", under: nil)
        self.addChild(play)
        self.addChild(play.label)
        
        let leaderboard = ButtonSprite(title: "Leaderboard", under: play)
        leaderboard.runOnClick = {
            GameViewController.mainView.showLeaderboards()
        }
        self.addChild(leaderboard)
        self.addChild(leaderboard.label)
        
        let share = ButtonSprite(title: "Share", under: leaderboard)
        share.runOnClick = {
            GameViewController.mainView.sendScores()
        }
        self.addChild(share)
        self.addChild(share.label)
        
        let rate = ButtonSprite(title: "Rate", under: share)
        rate.runOnClick = {
            GameViewController.mainView.link()
        }
        self.addChild(rate)
        self.addChild(rate.label)
        
        let specialScore = SpecialScore()
        specialScore.background.position = CGPoint(x: Constants.center.x, y: Constants.center.y + 140.yScaled)
        self.addChild(specialScore.background)
        self.addChild(specialScore.score)
        self.addChild(specialScore.levelTitle)
    }
}

class SpecialScore {
    
    lazy var background: SKSpriteNode = {
        let circle = SKShapeNode(circleOfRadius: 80.xScaled)
        circle.alpha = 0.30
        circle.fillColor = UIColor.white
        circle.strokeColor = UIColor.gray.lighterColor(percent: 20)
        circle.lineWidth = 5
        circle.zPosition = 4
        return SKSpriteNode(texture: SKView().texture(from: circle))
    }()
    
    lazy var score: SKLabelNode = {
        let label = SKLabelNode(title: String(GameModel.currentLevel), fontSize: 70.xScaled)
        label.position = CGPoint(x: self.background.position.x, y: self.background.position.y - 15.yScaled)
        label.alpha = 0.85
        label.zPosition = 5
        return label
    }()
    
    lazy var levelTitle: SKLabelNode = {
        let label = SKLabelNode(title: "Level", fontSize: 40.xScaled)
        label.position = CGPoint(x: self.background.position.x, y: self.background.position.y + 25.yScaled)
        label.zPosition = 6
        label.alpha = 0.60
        return label
    }()

}
