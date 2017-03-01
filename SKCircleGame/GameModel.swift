//
//  GameModel.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 11/21/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import SpriteKit
import GameKit

class GameModel {
    
    static var nextLevel: Int {
        let fromConfig = UserDefaults.standard.integer(forKey: "score")
        return (fromConfig == 0 ? 1 : fromConfig) + 1
    }
    
    static var currentLevel: Int {
        return nextLevel - 1
    }
    
    static var retries: Int {
        let fromConfig = UserDefaults.standard.integer(forKey: "retries")
        return 1
    }
    
    var clockwise = true

    var ball: BallSprite! = nil

    lazy var scoreLabel: ScoreLabel = ScoreLabel(scene: self.scene)
    
    var levelOneTrack: TrackSprite!
    var levelOneGoal: GoalSprite!
    
    let scene: GameScene!
    
    lazy var audio: AudioHelper = {
        return AudioHelper(scene: self.scene!)
    }()
    
    init(scene: GameScene, level: Int) {
        self.scene = scene
        self.scoreLabel.score = level
    }
    
    func createBall(time: Double) {
        ball = BallSprite(color: DynamicBackground.nextColor, view: scene.view!)
        ball.zPosition = 2
        ball.position = Constants.center
        scene.addChild(ball)
        
        let radians = CGFloat(CGFloat.radian(fromDegree: -25) + levelOneTrack.zRotation)
        
        let track = UIBezierPath(arcCenter: Constants.center, radius: CGFloat(Constants.xScaledIncrease + Constants.scaledRadius), startAngle: radians, endAngle: (radians + CGFloat(M_PI * 2)), clockwise: true)
        ball.action = SKAction.follow(track.cgPath, asOffset: false, orientToPath: true, duration: TimeInterval(time)).reversed()
    }
    
    func createBall(time: Double, rev: Bool) {
        ball = BallSprite(color: DynamicBackground.nextColor, view: scene.view!)
        ball.zPosition = 2
        ball.position = Constants.center
        scene.addChild(ball)
        
        // the first angle is 50 degrees, and half of that in radians is this
        let radians = CGFloat(CGFloat.radian(fromDegree: -25) + levelOneTrack.zRotation)
        
        let track: UIBezierPath = UIBezierPath(arcCenter: Constants.center, radius: CGFloat(Constants.xScaledIncrease + Constants.scaledRadius), startAngle: radians + levelOneTrack.zRotation, endAngle:  (radians + CGFloat(M_PI * 2)), clockwise: true)
        var action: SKAction = SKAction.follow(track.cgPath, asOffset: false, orientToPath: true, duration: TimeInterval(time))
        
        if rev {
            action = action.reversed()
        }

        ball.action = action
    }
    
    func updateBall() {
        let dx = ball.position.x - Constants.center.x
        let dy = ball.position.y - Constants.center.y
        
        let rad = atan2(dy, dx)
        
        let path = UIBezierPath(arcCenter: Constants.center, radius: CGFloat(Constants.xScaledIncrease + Constants.scaledRadius), startAngle: rad, endAngle: CGFloat.radian(fromDegree: 360) + rad, clockwise: true)
        
        var action = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, duration: TimeInterval(levelOneTrack.time))
        
        if levelOneTrack.clockwise! {
            action = action.reversed()
        }
        
        ball.action = action
    }
    
    func createTracks() {
        for level in 1...(self.scoreLabel.score + 1 > 5 ? 5 : self.scoreLabel.score + 1) {
            
            let goal = GoalSprite(level: level, model: self)
            let track = TrackSprite(level: level, model: self, goalSprite: goal)
            
            self.scene.addChild(goal)
            self.scene.addChild(track)
            
            if level == 1 {
                self.levelOneTrack = track
                self.levelOneGoal = goal
                self.createBall(time: track.time)
            }
            
        }
    }
    
    func applyTrackPhysics() {
        let trackPhysics = SKPhysicsBody(edgeChainFrom: TrackSprite.trackPathTextures[1]!.normalPath.cgPath)
        trackPhysics.affectedByGravity = false
        trackPhysics.collisionBitMask = 0
        trackPhysics.categoryBitMask = Catigory.track.rawValue
        trackPhysics.contactTestBitMask = Contact.ball.rawValue
        levelOneTrack.physicsBody = trackPhysics
    }
    
    func applyGoalPhysics() {
        let goalPhysics = SKPhysicsBody(edgeChainFrom: GoalSprite.goalPathTextures[1]!.normalPath.cgPath)
        goalPhysics.affectedByGravity = false
        goalPhysics.collisionBitMask = 0
        goalPhysics.categoryBitMask = Catigory.goal.rawValue
        goalPhysics.contactTestBitMask = Contact.ball.rawValue
        levelOneGoal.physicsBody = goalPhysics
    }

    func addTopLevel() {
        let goal = GoalSprite(level: 6, model: self)
        let track = TrackSprite(level: 6, model: self, goalSprite: goal)
        
        scene.addChild(goal)
        scene.addChild(track)
        
        track.shrink()
    }
    
    func updateScore() {
        scoreLabel.score -= 1
        
        if scoreLabel.score == 0 {
            win()
        }
    }
    
    func win() {
        let score = GKScore(leaderboardIdentifier: "spinzone.levels", player: GKLocalPlayer.localPlayer())
        score.value = Int64(GameModel.nextLevel)
        GKScore.report([score], withCompletionHandler: { error in })
        
        // store the current score before next scene loads
        UserDefaults.standard.set(GameModel.nextLevel, forKey: "score")
        
        if (true) {
            earnRetry()
        } else {
            presentNextScene()
        }
    }
    
    func presentNextScene() {
        let transition = SKTransition.push(with: .left, duration: 0.5)
        transition.pausesOutgoingScene = true
        transition.pausesIncomingScene = true
        
        let nextScene = GameScene(size: Constants.currentSize)
        nextScene.scaleMode = .aspectFill
        nextScene.backgroundColor = self.scene.backgroundColor
        self.scene.view?.presentScene(nextScene, transition: transition)
    }
    
    func earnRetry() {
        if (true/*GameModel.nextLevel % 10 == 1*/) { // 11, 21, etc, give a new retry
            let alert = UIAlertController(title: "1 Rety", message: "Congradulations! You have earned 1 Rety, earn one every 10 Levels", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: { alert in
                UserDefaults.standard.set(GameModel.retries + 1, forKey: "retries")
            })
            
            alert.addAction(action)
            alert.present((self.scene.view!.window!.rootViewController)!, animated: true, completion: {
                self.presentNextScene()
            })
        }
    }
    
    func lose() {
        let transition = SKTransition.push(with: .down, duration: 0.5)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false
        
        let nextScene = GameLoseScene(size: Constants.currentSize)
        nextScene.backgroundColor = self.scene.backgroundColor
        self.scene.view?.presentScene(nextScene, transition: transition)
    }
}
